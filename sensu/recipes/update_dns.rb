include_recipe "route53"

instance = search("aws_opsworks_instance","self:true").first
Chef::Log.info("Found: #{instance}")

private_ip = instance['private_ip']
Chef::Log.info("IP: #{private_ip}")

route53_record "create amqp dns record" do
  name node[:sensu][:route53][:amqp][:endpoint]
  value private_ip
  type node[:sensu][:route53][:type]
  zone_id node[:sensu][:route53][:zone_id]
  ttl node[:sensu][:route53][:ttl]
  overwrite true
  action :create
end

route53_record "create server dns record" do
  name node[:sensu][:route53][:server][:endpoint]
  value private_ip
  type node[:sensu][:route53][:type]
  zone_id node[:sensu][:route53][:zone_id]
  ttl node[:sensu][:route53][:ttl]
  overwrite true
  action :create
end

route53_record "create api dns record" do
  name node[:sensu][:route53][:api][:endpoint]
  value private_ip
  type node[:sensu][:route53][:type]
  zone_id node[:sensu][:route53][:zone_id]
  ttl node[:sensu][:route53][:ttl]
  overwrite true
  action :create
end

route53_record "create redis dns record" do
  name node[:sensu][:route53][:redis][:endpoint]
  value private_ip
  type node[:sensu][:route53][:type]
  zone_id node[:sensu][:route53][:zone_id]
  ttl node[:sensu][:route53][:ttl]
  overwrite true
  action :create
end
