require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.13.0.zip'
  sha1 '179e9a2111de3cc1fa06629f5faebd3d50d0525c'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
