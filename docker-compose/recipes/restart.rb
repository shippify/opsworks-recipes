execute 'restart containers' do
    cwd '/docker-compose/'
    command 'docker-compose restart'
end
