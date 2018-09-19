
#clone repository
app = search("aws_opsworks_app", "shortname:#{node['app']}").first
application_git "/srv/#{node['app']}" do
  repository app['app_source']['url']
  deploy_key app['app_source']['ssh_key']
end

#export environment variables
ruby_block "export_vars" do
  block do
    app['environment'].each do |env_var|
      ENV["#{env_var[0]}"] = env_var[1]
    end
  end
end

#install dependencies
bash 'yarn install' do
  cwd '/srv/keyserver'
  code <<-EOH
      yarn --frozen-lockfile
    EOH
  end

#restart supervisor
bash 'restart_supervisor' do
  code <<-EOH
    cp /srv/keyserver/supervisor.conf /etc/supervisor/conf.d/api_server.conf
    service supervisord restart
  EOH
end
