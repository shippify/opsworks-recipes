package 'git'

git "/home/ec2-user/repo1" do
  repository https://github.com/GianniCarlo/application_git
  action :checkout
end
