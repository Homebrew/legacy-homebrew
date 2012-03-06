require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.5.2.3.zip'
  md5 'fa1e050b35ce9e7f4a2017f251c5e2bb'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
