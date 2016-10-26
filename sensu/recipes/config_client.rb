template '/etc/sensu/conf.d/client.json' do
  source 'client.json.erb'
  owner 'root'
  group 'root'
  mode 00644
end
