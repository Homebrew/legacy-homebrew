require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.9.0.zip'
  sha1 '3fb4299f95955dd5a2dc9302b8a2107faee75308'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
