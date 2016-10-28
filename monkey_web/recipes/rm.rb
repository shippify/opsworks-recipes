execute 'remove containers' do
    only_if { Dir.exist?("/srv/monkey_web/") }
    cwd '/srv/monkey_web/'
    command 'docker-compose rm --force'
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end
