
node['lambda'].each do |lambdaFunction|
  payload = "'{"

  lambdaFunction['payload'].each do |key, value|
    if payload != "'{"
      payload = payload + ","
    end
    payload = payload + "\"#{key}\":\"#{value}\""
  end

  payload = payload + "}'"

  bash 'invoke_function' do
    code <<-EOH
    aws lambda invoke --invocation-type RequestResponse --function-name #{lambdaFunction['function-arn']} --region #{lambdaFunction['region']} --payload #{payload} lambda_output.txt
    EOH
  end

end
