require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.7.zip'
  sha1 'd0225571d5416009f6cd2d62856f0d9307a4e608'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
