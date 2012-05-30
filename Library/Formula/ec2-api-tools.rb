require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://s3.amazonaws.com/ec2-downloads/ec2-api-tools-1.5.3.1.zip'
  md5 'ad74023e00a73fdf7f1967f37c85f22b'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
