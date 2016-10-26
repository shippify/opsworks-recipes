template '/etc/sensu/conf.d/redis.json' do
  source 'redis.json.erb'
  owner 'root'
  group 'root'
  mode 00644
end
