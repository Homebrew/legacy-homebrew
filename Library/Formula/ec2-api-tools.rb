require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.5.3.1.zip'
  sha1 'ffffe67aa4ea34597210f4ea5cfc0797c5871ebf'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
