execute "DockerHub login" do
  action :run
  command "/usr/bin/docker login -e #{node[:DockerHub][:login][:email]} -u #{node[:DockerHub][:login][:username]} -p #{node[:DockerHub][:login][:password]}"
end
