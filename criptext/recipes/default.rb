package 'git'

git "/home/ec2-user/repo1" do
  repository https://github.com/myname/repo1.git
  action :checkout
end
