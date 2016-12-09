
instance = search("aws_opsworks_instance", "self:true").first

node['balancers'].each do |balancer|

  targets = ""

  balancer['ports'].each do |port_var|
    targets = targets + "Id=#{instance['ec2_instance_id']},Port=#{port_var} "
  end

  bash 'deregister_balancer' do
    code <<-EOH
    aws elbv2 deregister-targets --target-group-arn #{balancer['target-group-arn']} --targets #{targets} --region #{balancer['region']}
    EOH
  end

end
