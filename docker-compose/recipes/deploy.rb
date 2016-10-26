directory '/docker-compose' do
  owner 'root'
  group 'root'
  mode  '00755'
end

my_layer = search("aws_opsworks_layer").first
Chef::Log.info("********** The layer's name is '#{my_layer['name']}' **********")

template '/docker-compose/docker-compose.yml' do
  source 'docker-compose.yml.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables ({
    :my_layer => my_layer['name']
  })
end

include_recipe 'docker-compose::pull'
include_recipe 'docker-compose::stop'
include_recipe 'docker-compose::rm'
include_recipe 'docker-compose::up'
