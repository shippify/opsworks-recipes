unless node['app']
  Chef::Application.fatal!("There is no app specified in the custom JSON.")
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
end

# clone repository
application_git "/srv/#{node['app']}" do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  deploy_key app['app_source']['ssh_key']
  enable_submodules true
  notifies :create, "ruby_block[insert_line]", :immediately
end
