package 'git'

git "/home/ec2-user/repo1" do
  repository https://github.com/criptext/opsworks-recipes
  action :checkout
end
