#package 'git'

#git '/home/ec2-user/monkey-web' do
#  repository 'https://github.com/Criptext/Monkey-Web-API'
#end

package 'application_git'

application_git '/home/ec2-user/monkey_web' do
  repository 'git@github.com:Criptext/Monkey-Web-API.git'
  deploy_key chef_vault_item('deploy_keys', 'monkey_web')['key']
end
