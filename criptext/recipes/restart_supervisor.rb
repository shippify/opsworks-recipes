bash 'restart_supervisor' do
  code <<-EOH
    cp /srv/keyserver/supervisor.conf /etc/supervisor/conf.d/api_server.conf
    service supervisord restart
  EOH
end
