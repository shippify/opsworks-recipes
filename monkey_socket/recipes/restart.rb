if File.exist?('/srv/monkey_socket/docker-compose.yml')
  execute 'restart containers' do
      cwd '/srv/monkey_socket/'
      command 'docker-compose restart'
  end
end
