
instance = search("aws_opsworks_instance", "self:true").first

bash 'register_balancer' do
  code <<-EOH
  aws elbv2 deregister-targets --target-group-arn #{node['target-group-arn']} --targets Id=#{instance['ec2_instance_id']} --region #{node['region']}
  EOH
end
