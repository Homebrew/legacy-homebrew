require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.5.2.5.zip'
  md5 'a9926c03fe3c05ff2e7fed3ae1b31634'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
