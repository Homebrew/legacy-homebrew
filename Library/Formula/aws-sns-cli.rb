require 'formula'

class AwsSnsCli < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/3688'
  url 'http://sns-public-resources.s3.amazonaws.com/SimpleNotificationServiceCli-2010-03-31.zip'
  # The version in the tarball is the API version; this is the tool version
  version '2012-03-27'
  sha1 'fcb6f651275b88f6225ed94f51568936ccba9e6d'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_SNS_HOME"
  end
end
