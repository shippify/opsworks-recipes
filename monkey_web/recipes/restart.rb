execute 'restart containers' do
    only_if { Dir.exist?("/srv/monkey_web/") }
    cwd '/srv/monkey_web/'
    command 'docker-compose restart'
end
