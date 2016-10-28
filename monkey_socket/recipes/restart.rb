execute 'restart containers' do
    cwd '/srv/monkey_socket/'
    command 'docker-compose restart'
end
