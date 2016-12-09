node['commands'].each do |command|
  bash 'run_command' do
    code <<-EOH
    #{command}
    EOH
  end
end
