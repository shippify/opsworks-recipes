unless node['app']
  Chef::Application.fatal!("There is no app specified in the custom JSON.")
end

if File.exist?("/srv/#{node['app']}/docker-compose.yml")
  execute 'remove containers' do
      only_if { Dir.exist?("/srv/#{node['app']}/") }
      cwd "/srv/#{node['app']}/"
      command 'docker-compose rm --force -v'
      case node[:platform]
      when 'ubuntu'
        environment 'COMPOSE_API_VERSION' => '1.18'
      end
  end
end
