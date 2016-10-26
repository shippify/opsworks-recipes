template '/etc/sensu/conf.d/amqp.json' do
  source 'amqp.json.erb'
  owner 'root'
  group 'root'
  mode 00644
end
