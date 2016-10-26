execute 'up containers' do
    cwd '/docker-compose/'
    command 'docker-compose up -d'
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end
