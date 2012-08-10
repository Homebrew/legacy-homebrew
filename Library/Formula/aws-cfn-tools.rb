require 'formula'

class AwsCfnTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/AWS-CloudFormation/2555753788650372'
  url 'https://s3.amazonaws.com/cloudformation-cli/AWSCloudFormation-cli.zip'
  version '1.0.9'
  md5 'c18d85826f97fe579ba68c9c52973776'

  depends_on 'ec2-api-tools'

  def install
    standard_install
  end

  def caveats
    puts standard_instructions "AWS_CLOUDFORMATION_HOME"
    puts  <<-EOS.undent
      export AWS_CREDENTIAL_FILE="<Path to the credentials file>"

      Create the credential files with chmod 600 permissions containing two lines:
      AWSAccessKeyId=<Your AWS Access ID>
      AWSSecretKey=<Your AWS Secret Key>

    EOS
  end
end
