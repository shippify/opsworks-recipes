directory '/etc/sensu' do
  owner 'root'
  group 'root'
  mode  '00755'
end

directory '/etc/sensu/conf.d' do
  owner 'root'
  group 'root'
  mode  '00755'
end
