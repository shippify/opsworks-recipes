
# clone repository
app = search("aws_opsworks_app", "shortname:monkey_web").first
application_git '/srv/monkey_web' do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  deploy_key app['app_source']['ssh_key']
  notifies :create, 'file[/srv/monkey_web/app.env]', :immediately
  notifies :create, 'file[/srv/monkey_web/docker-compose.yml]', :immediately
  notifies :create, 'ruby_block[insert_line]', :immediately
end

# make sure file app.env exists
file '/srv/monkey_web/app.env' do
  content ''
  action :nothing
end

# create docker-compose file if it doesn't exist
# necessary 'if' because at compile time docker-compose file doesn't exist
if File.exist?('/srv/monkey_web/docker-compose-prod.yml')
  file '/srv/monkey_web/docker-compose.yml' do
    content IO.read('/srv/monkey_web/docker-compose-prod.yml')
    action :nothing
  end
end

# populate app.env file
ruby_block "insert_line" do
  block do
    app['environment'].each do |env_var|
      file = Chef::Util::FileEdit.new("/srv/monkey_web/app.env")
      file.insert_line_if_no_match("/#{env_var[0]}=#{env_var[1]}/", "#{env_var[0]}=#{env_var[1]}")
      file.write_file
    end
  end
  action :nothing
end
