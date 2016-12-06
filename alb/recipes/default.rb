
instance = search("aws_opsworks_instance", "self:true").first

Chef::Log.info("********** group arn '#{node['target-group-arn']}' **********")
Chef::Log.info("********** id instance '#{instance['ec2_instance_id']}' **********")
Chef::Log.info("********** region '#{instance['region']}' **********")

bash 'register_balancer' do
  code <<-EOH
  aws elbv2 register-targets --target-group-arn #{node['target-group-arn']} --targets Id=#{instance['ec2_instance_id']} --region #{node['region']}
  EOH
end
