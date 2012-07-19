require 'formula'

class AwsSnsCli < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/3688'
  url 'http://sns-public-resources.s3.amazonaws.com/SimpleNotificationServiceCli-2010-03-31.zip'
  sha1 'e41084d375328f502546c303bc848f9ce9d1daa4'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_SNS_HOME"
  end
end
