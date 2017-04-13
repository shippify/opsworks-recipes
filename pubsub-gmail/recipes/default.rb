bash 'install_command' do
	action:nothing
code <<-EOH
yum install google-cloud-sdk
EOH
end

bash 'run_command' do
	action:nothing
	notifies :run, 'bash[install_command]', :immediately
code <<-EOH
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
EOH
end

bash 'update_command' do
	notifies :run, 'bash[run_command]', :immediately
code <<-EOH
yum install -y python27
EOH
end