unless node['app']
  Chef::Application.fatal!("There is no app specified in the custom JSON.")
end

# get app
app = search("aws_opsworks_app", "shortname:#{node['app']}").first

# clone repository
application_git "/srv/#{node['app']}" do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  deploy_key app['app_source']['ssh_key']
  enable_submodules true
  action :nothing
end
