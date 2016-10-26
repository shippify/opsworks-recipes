include_recipe "route53"

instance = search("aws_opsworks_instance","self:true").first
Chef::Log.info("Found: #{instance}")

private_ip = instance['private_ip']
Chef::Log.info("IP: #{private_ip}")
