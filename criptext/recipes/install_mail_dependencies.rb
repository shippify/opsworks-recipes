remote_file '/root/node_install.sh' do
  source 'https://rpm.nodesource.com/setup_8.x'
end

bash 'install node from RPM' do
  code 'bash /root/node_install.sh'
end

remote_file '/root/nvm_install.sh' do
  source 'https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh'
end

bash 'install node via nvm' do
  code <<-EOH
    bash '/root/nvm_install.sh'
    source '/root/.nvm/nvm.sh'
    nvm install 10.10
  EOH
end

remote_file '/etc/yum.repos.d/yarn.repo' do
  source 'https://dl.yarnpkg.com/rpm/yarn.repo'
end

package 'yarn' 

bash 'install supervisor' do
    code <<-EOH
      pip install -U supervisor
      echo_supervisord_conf > /etc/supervisor/supervisord.conf
      mkdir /var/log/supervisor
      cat > /var/log/supervisor/supervisord.log
    EOH
  end

directory '/etc/init.d' do
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/etc/supervisor/supervisord.conf' do
  source 'supervisord.conf'
  mode '0511'
end

cookbook_file '/etc/init.d/supervisord' do
  source 'supervisord'
  mode '0711'
end



