# copy files
ruby_block "copy_files" do
  block do
    node['copy-files'].each do |file_var|
      FileUtils::cp "#{file_var['source']}", "/#{file_var['destination']}"
    end
  end
  action :create
end
