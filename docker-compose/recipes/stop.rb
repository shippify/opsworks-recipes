execute 'stop containers' do
    cwd '/docker-compose/'
    command 'docker-compose stop'
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end
