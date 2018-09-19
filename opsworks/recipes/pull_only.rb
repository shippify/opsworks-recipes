unless node['app']
  Chef::Application.fatal!("There is no app specified in the custom JSON.")
end

# get app
app = search("aws_opsworks_app", "shortname:#{node['app']}").first

# clone repository
application_git "/srv/#{node['app']}" do
  Chef::Log.debug("Clonning repository into /srv/#{node['app']}")
  Chef::Log.debug("with url: #{app['app_source']['url']}")
  repository app['app_source']['url']
  Chef::Log.debug("with revision: #{app['app_source']['revision']}")
  revision app['app_source']['revision']
  Chef::Log.debug("with ssh_key /srv/#{app['app_source']['ssh_key']}")
  deploy_key app['app_source']['ssh_key']
  enable_submodules true
  action :nothing
end
