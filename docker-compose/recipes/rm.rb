execute 'remove containers' do
    cwd '/docker-compose/'
    command 'docker-compose rm --force'
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end
