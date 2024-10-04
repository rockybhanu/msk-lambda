pip install -r lambda_function/requirements.txt -t lambda_function/

Compress-Archive -Path .\lambda_function\* -DestinationPath .\lambda_function\lambda.zip