execute 'clean untagged images' do
    cwd '/docker-compose/'
    command '/usr/bin/docker rmi $(/usr/bin/docker images -q -f dangling=true)'
end
