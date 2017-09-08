# copy external env files
ruby_block "copy_files" do
  block do
    node['copy-files'].each do |file_var|
      file "#{file_var['destination']}" do
        owner 'root'
        group 'root'
        mode 0755
        content lazy { ::File.open("#{file_var['source']}").read }
        action :create
      end
    end
  end
  action :create
end
