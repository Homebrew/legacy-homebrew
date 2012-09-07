require 'formula'

class AwsCfnTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/AWS-CloudFormation/2555753788650372'
  url 'https://s3.amazonaws.com/cloudformation-cli/AWSCloudFormation-cli.zip'
  version '1.0.10'
  sha1 '656a81c5f3078dc7550a0512aa97b67ebd0331f1'

  depends_on 'ec2-api-tools'

  def install
    standard_install
  end

  def caveats
    s = standard_instructions "AWS_CLOUDFORMATION_HOME"
    s += <<-EOS.undent
      export AWS_CREDENTIAL_FILE="<Path to the credentials file>"

      Create the credential files with chmod 600 permissions containing two lines:
      AWSAccessKeyId=<Your AWS Access ID>
      AWSSecretKey=<Your AWS Secret Key>
    EOS
    return s
  end
end
