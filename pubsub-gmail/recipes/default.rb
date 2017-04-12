bash 'run_command' do
  code <<-EOH
		yum install google-cloud-sdk && gcloud init
  EOH
end
