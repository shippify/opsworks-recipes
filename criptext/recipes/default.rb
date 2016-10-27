package 'application'
package 'application_git'

application '/srv' do
  git 'https://github.com/GianniCarlo/application_git'
end
