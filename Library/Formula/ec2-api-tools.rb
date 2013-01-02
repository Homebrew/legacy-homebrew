require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.6.0.zip'
  sha1 'e2461caf2b95e97e991f3d22b63516ed46a270f0'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
