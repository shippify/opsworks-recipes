# copy files
ruby_block "copy_files" do
  block do
    unless node['copy-files'].nil?
      node['copy-files'].each do |file_var|
        FileUtils::cp "#{file_var['source']}", "/#{file_var['destination']}"
      end
    end
  end
  action :create
end
