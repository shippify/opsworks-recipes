
path_supervisor_conf = "/etc/supervisor/conf.d/api_server.conf"

#clone repository
app = search("aws_opsworks_app", "shortname:#{node['app']}").first
application_git "/srv/#{node['app']}" do
  repository app['app_source']['url']
  deploy_key app['app_source']['ssh_key']
end

#copy supervisor conf
bash 'copy_supervisor_conf_file' do
  code <<-EOH
    cp /srv/keyserver/supervisor.conf #{path_supervisor_conf}
  EOH
end

#replace environment variables to supervisor conf
supervisor_conf_file = File.read(path_supervisor_conf)
ruby_block "export_vars" do
  block do
    app['environment'].each do |env_var|
      supervisor_conf_file = supervisor_conf_file.gsub("%(ENV_#{env_var[0]})s", env_var[1])
    end
  end
end
File.open(path_supervisor_conf, "w") {|file| file.puts supervisor_conf_file }

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
    cp /srv/keyserver/supervisor.conf #{path_supervisor_conf}
    service supervisord restart
  EOH
end
