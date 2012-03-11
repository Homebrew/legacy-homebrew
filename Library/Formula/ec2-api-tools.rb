require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.5.2.4.zip'
  md5 '928967de271e15d3d1518730f384600f'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
