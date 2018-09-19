
app = search("aws_opsworks_app", "shortname:#{node['app']}").first
application_git "/srv/#{node['app']}" do
  Chef::Log.debug("with url: #{app['app_source']['url']}")
  repository app['app_source']['url']
  Chef::Log.debug("with ssh_key /srv/#{app['app_source']['ssh_key']}")
  deploy_key app['app_source']['ssh_key']
end

bash 'restart_supervisor' do
  code <<-EOH
    cp /srv/keyserver/supervisor.conf /etc/supervisor/conf.d/api_server.conf
    service supervisord restart
  EOH
end
