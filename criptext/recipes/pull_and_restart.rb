
app = search("aws_opsworks_app", "shortname:#{node['app']}").first
application_git "/srv/#{node['app']}" do
  repository app['app_source']['url']
  deploy_key app['app_source']['ssh_key']
end

bash 'yarn install' do
  cwd '/srv/keyserver'
  code <<-EOH
      yarn --frozen-lockfile
    EOH
  end

bash 'restart_supervisor' do
  code <<-EOH
    cp /srv/keyserver/supervisor.conf /etc/supervisor/conf.d/api_server.conf
    service supervisord restart
  EOH
end
