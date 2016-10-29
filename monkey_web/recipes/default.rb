
# clone repository
app = search("aws_opsworks_app", "shortname:monkey_web").first
application_git '/srv/monkey_web' do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  deploy_key app['app_source']['ssh_key']
end

# make sure file app.env exists
file '/srv/monkey_web/app.env' do
  content ''
  action :create
end

# create docker-compose file if it doesn't exist
# necessary 'if' because at compile time docker-compose file doesn't exist
if File.exist?('/srv/monkey_web/docker-compose-prod.yml')
  file '/srv/monkey_web/docker-compose.yml' do
    content IO.read('/srv/monkey_web/docker-compose-prod.yml')
    action :create
  end
end

# populate app.env file
app['environment'].each do |env_var|
  ruby_block "insert_line" do
    block do
      file = Chef::Util::FileEdit.new("/srv/monkey_web/app.env")
      file.insert_line_if_no_match("/#{env_var[0]}=#{env_var[1]}/", "#{env_var[0]}=#{env_var[1]}")
      file.write_file
    end
  end
end
