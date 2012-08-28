require 'formula'

class AwsSnsCli < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/3688'
  url 'http://sns-public-resources.s3.amazonaws.com/SimpleNotificationServiceCli-2010-03-31.zip'
  # The version in the tarball is the API version; this is the tool version
  version '2012-03-27'
  sha1 'b2cb8645887263c5550271be3b564e102c99943d'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_SNS_HOME"
  end
end
