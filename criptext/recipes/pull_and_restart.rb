
#Chef::Log.level = :debug
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
    cp /srv/#{node['app']}/supervisor.conf #{path_supervisor_conf}
  EOH
end

#replace environment variables to supervisor conf
ruby_block "replace_vars" do
  block do
    app['environment'].each do |env_var|
      file = Chef::Util::FileEdit.new(path_supervisor_conf)
      file.search_file_replace(/%\(ENV_#{env_var[0]}\)s/, "#{env_var[1]}")
      file.write_file
    end
  end
end

#install dependencies
bash 'yarn install' do
  cwd "/srv/#{node['app']}"
  code <<-EOH
      yarn --frozen-lockfile
    EOH
  end

#setup cron jobs
cron 'delete_blacklisted_events' do
  action :create
  minute '00'
  hour '13'
  weekday '1'
  user 'ec2-user'
  mailto "javier@criptext.com,daniel@criptext.com"
  environment app['environment']
  command "/usr/bin/node /srv/keyserver/scripts/src/purge-blacklisted-events.js"
end

cron 'delete_blacklisted_emails' do
  action :create
  minute '00'
  hour '13'
  weekday '1'
  user 'ec2-user'
  mailto "javier@criptext.com,daniel@criptext.com"
  environment app['environment']
  command "/usr/bin/node /srv/keyserver/scripts/src/purge-blacklisted-emails.js"
end

cron 'delete_blacklisted_emails' do
  action :create
  minute '00'
  hour '13'
  weekday '1'
  user 'ec2-user'
  mailto "javier@criptext.com,daniel@criptext.com"
  environment app['environment']
  command "/usr/bin/node /srv/keyserver/api-server/src/scripts/deleteAccountsForInactivity.js"
end

#restart supervisor
bash 'restart_supervisor' do
  code <<-EOH
    service supervisord restart
  EOH
end
