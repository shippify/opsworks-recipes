package 'Install Docker' do
  case node[:platform]
  when 'redhat', 'centos', 'amazon'
    package_name 'docker'
  when 'ubuntu', 'debian'
    package_name 'docker.io'
  end
end

service 'Docker' do
  service_name 'docker'
  supports restart: true, reload: true
  action %w(enable start)
end

python_package 'docker-compose' do
  version '1.10.1'
end

bash 'update_docker_compose' do
  code <<-EOH
  sudo pip install docker-compose --upgrade
  EOH
end

include_recipe 'docker-compose::cron'
