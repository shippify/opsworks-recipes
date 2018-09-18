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


yum_repository 'yarn repo' do
  action :create
  baseurl 'https://dl.yarnpkg.com/rpm/yarn.repo'
end
package "yarn"
