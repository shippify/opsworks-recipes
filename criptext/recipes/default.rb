application node['conf-cookbook']['app_dir'] do
  git app['app_source']['url'] do
    deploy_key app['app_source']['ssh_key']
  end
end
