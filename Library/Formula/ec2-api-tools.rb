require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.5.2.zip'
  sha1 '35c4344edf7c3add57ea4c2c53a0d43f922c2e69'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
