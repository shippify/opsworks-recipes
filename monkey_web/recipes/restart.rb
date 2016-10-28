execute 'restart containers' do
    cwd '/srv/monkey_web/'
    command 'docker-compose restart'
end
