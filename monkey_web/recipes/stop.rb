if File.exist?('/srv/monkey_web/docker-compose.yml')
  execute 'stop containers' do
      only_if { Dir.exist?("/srv/monkey_web/") }
      cwd '/srv/monkey_web/'
      command 'docker-compose stop'
      case node[:platform]
      when 'ubuntu'
        environment 'COMPOSE_API_VERSION' => '1.18'
      end
  end
end
