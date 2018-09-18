bash 'restart_supervisor' do
  code <<-EOH
    mkdir -p /etc/supervisor/conf.d
    cp /srv/keyserver/supervisor.conf /etc/supervisor/conf.d/api_server.conf
    service supervisord restart
  EOH
end
