unless node['app']
  Chef::Application.fatal!("There is no app specified in the custom JSON.")
end

# clone repository
application_git "/srv/#{node['app']}" do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  deploy_key app['app_source']['ssh_key']
  enable_submodules true
  notifies :create, "ruby_block[insert_line]", :immediately
end
