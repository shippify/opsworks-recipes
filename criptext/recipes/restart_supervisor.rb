bash 'restart_supervisor' do
	action:nothing
code <<-EOH
sudo service supervisord restart
EOH
end