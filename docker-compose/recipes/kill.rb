execute 'kill containers' do
    cwd '/docker-compose/'
    command 'docker-compose kill'
    case node[:platform]
    when 'ubuntu'
      environment 'COMPOSE_API_VERSION' => '1.18'
    end
end
