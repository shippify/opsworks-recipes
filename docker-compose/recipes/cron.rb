cron "clean-unused-containers" do
  hour "16"
  minute "00"
  user "root"
  command "/usr/bin/docker rm $(/usr/bin/docker ps -a -q) > /dev/null 2>&1"
end
