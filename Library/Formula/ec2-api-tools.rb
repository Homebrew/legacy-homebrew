require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.5.5.0.zip'
  md5 '51c79657e921cfaaea8d0bff98bbc24b'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
