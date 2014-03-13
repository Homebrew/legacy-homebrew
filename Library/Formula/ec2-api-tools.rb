require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.12.2.zip'
  sha1 '96bea739ee32326c6826fe22ab778320fde841a4'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
