template '/etc/sensu/conf.d/api.json' do
  source 'api.json.erb'
  owner 'root'
  group 'root'
  mode 00644
end
