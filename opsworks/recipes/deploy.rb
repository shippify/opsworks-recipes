unless node['app']
  Chef::Application.fatal!("There is no app specified in the custom JSON.")
end

execute 'up-containers' do
    only_if do ::Dir.exists?("/srv/#{node['app']}") end
    cwd "/srv/#{node['app']}/"
    command 'docker-compose up -d --build'
    action :nothing
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end

execute 'remove-containers' do
    only_if do ::Dir.exists?("/srv/#{node['app']}") end
    cwd "/srv/#{node['app']}/"
    command 'docker-compose rm --force'
    action :nothing
    notifies :run, 'execute[up-containers]', :immediately
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end

execute 'stop-containers' do
    only_if do ::Dir.exists?("/srv/#{node['app']}") end
    cwd "/srv/#{node['app']}/"
    command 'docker-compose stop'
    action :nothing
    notifies :run, 'execute[remove-containers]', :immediately
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end

# create docker-compose file
file "/srv/#{node['app']}/docker-compose.yml" do
    action :nothing
    content lazy { IO.read("/srv/#{node['app']}/docker-compose-prod.yml") }
    only_if do ::File.exists?("/srv/#{node['app']}/docker-compose-prod.yml") end
    notifies :run, 'execute[stop-containers]', :immediately
end

# get app
app = search("aws_opsworks_app", "shortname:#{node['app']}").first
# populate app.env file
ruby_block "insert_line" do
  block do
    app['environment'].each do |env_var|
      file = Chef::Util::FileEdit.new("/srv/#{node['app']}/app.env")
      file.insert_line_if_no_match("/#{env_var[0]}=#{env_var[1]}/", "#{env_var[0]}=#{env_var[1]}")
      file.write_file
    end
  end
  action :nothing
  notifies :create, "file[/srv/#{node['app']}/docker-compose.yml]", :immediately
end

# create external env files
ruby_block "fill_external_files" do
  block do
    node['external-files'].each do |file_var|
      file = Chef::Util::FileEdit.new("/srv/#{node['app']}/#{file_var['path']}")
      env_var = file_var['environment']
      file.insert_line_if_no_match("/#{env_var[0]}=#{env_var[1]}/", "#{env_var[0]}=#{env_var[1]}")
      file.write_file
    end
  end
  action :nothing
  notifies :create, "ruby_block[insert_line]", :immediately
end

# make sure all external files exists
ruby_block "create_external_files" do
  block do
    node['external-files'].each do |file_var|
      file "/srv/#{node['app']}/#{file_var['path']}" do
        content ''
        action :create
        only_if do ::Dir.exists?("/srv/#{node['app']}") end
      end
    end
  end
  action :nothing
  notifies :create, "ruby_block[fill_external_files]", :immediately
end

# make sure file app.env exists
file "/srv/#{node['app']}/app.env" do
  content ''
  action :nothing
  only_if do ::Dir.exists?("/srv/#{node['app']}") end
  notifies :create, 'ruby_block[create_external_files]', :immediately
end

# delete previous folder
directory "/srv/#{node['app']}" do
  recursive true
  action :delete
end

# clone repository
application_git "/srv/#{node['app']}" do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  deploy_key app['app_source']['ssh_key']
  notifies :create, "file[/srv/#{node['app']}/app.env]", :immediately
end
