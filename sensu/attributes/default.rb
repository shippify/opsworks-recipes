default[:sensu][:subscriptions] = ["default"]
default[:sensu][:route53][:amqp][:endpoint] = 'rabbitmq.sensu.internal'
default[:sensu][:route53][:redis][:endpoint] = 'redis.sensu.internal'
default[:sensu][:route53][:server][:endpoint] = 'server.sensu.internal'
default[:sensu][:route53][:api][:endpoint] = 'api.sensu.internal'
default[:sensu][:route53][:type] = 'A'
default[:sensu][:route53][:zone_id] = 'XXXXXXXXXXXX'
default[:sensu][:route53][:ttl] = 60
