require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.1.2.zip'
  md5 'bd1ae5df986446243f267cb02b9b230a'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
