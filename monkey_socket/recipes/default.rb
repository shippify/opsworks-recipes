execute 'up-containers' do
    only_if do ::Dir.exists?('/srv/monkey_socket') end
    cwd '/srv/monkey_socket/'
    command 'docker-compose up -d --build'
    action :nothing
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end

execute 'remove-containers' do
    only_if do ::Dir.exists?('/srv/monkey_socket') end
    cwd '/srv/monkey_socket/'
    command 'docker-compose rm --force'
    action :nothing
    notifies :run, 'execute[up-containers]', :immediately
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end

execute 'stop-containers' do
    only_if do ::Dir.exists?('/srv/monkey_socket') end
    cwd '/srv/monkey_socket/'
    command 'docker-compose stop'
    action :nothing
    notifies :run, 'execute[remove-containers]', :immediately
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end

# create docker-compose file
file '/srv/monkey_socket/docker-compose.yml' do
    action :nothing
    content lazy { IO.read('/srv/monkey_socket/docker-compose-prod.yml') }
    only_if do ::File.exists?('/srv/monkey_socket/docker-compose-prod.yml') end
    notifies :run, 'execute[stop-containers]', :immediately
end

# get app
app = search("aws_opsworks_app", "shortname:monkey_socket").first
# populate app.env file
ruby_block "insert_line" do
  block do
    app['environment'].each do |env_var|
      file = Chef::Util::FileEdit.new("/srv/monkey_socket/app.env")
      file.insert_line_if_no_match("/#{env_var[0]}=#{env_var[1]}/", "#{env_var[0]}=#{env_var[1]}")
      file.write_file
    end
  end
  action :nothing
  notifies :create, 'file[/srv/monkey_socket/docker-compose.yml]', :immediately
end

# make sure file app.env exists
file '/srv/monkey_socket/app.env' do
  content ''
  action :nothing
  only_if do ::Dir.exists?('/srv/monkey_socket') end
  notifies :create, 'ruby_block[insert_line]', :immediately
end

# delete previous folder
directory '/srv/monkey_socket' do
  recursive true
  action :delete
end

# clone repository
application_git '/srv/monkey_socket' do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  deploy_key app['app_source']['ssh_key']
  notifies :create, 'file[/srv/monkey_socket/app.env]', :immediately
end
