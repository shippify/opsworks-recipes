
instance = search("aws_opsworks_instance", "self:true").first

targets = ""

node['ports'].each do |port_var|
  targets = targets + "Id=#{instance['ec2_instance_id']},Port=#{port_var} "
end

bash 'register_balancer' do
  code <<-EOH
  aws elbv2 deregister-targets --target-group-arn #{node['target-group-arn']} --targets #{targets} --region #{node['region']}
  EOH
end
