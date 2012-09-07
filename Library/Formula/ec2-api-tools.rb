require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.1.2.zip'
  sha1 '7bd0f294d9661db403d2615407a253b6ee0aab3e'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
