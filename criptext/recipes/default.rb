package 'git'
package 'application'
package 'application_git'

application '/home/ec2-user/repo1' do
  # Application resource properties.
  owner 'root'
  group 'root'

  git '/home/ec2-user/repo' do
    repository 'https://github.com/criptext/opsworks-recipes'
  end
end
