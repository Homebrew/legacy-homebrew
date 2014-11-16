require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.7.1.0.zip'
  sha1 '154acfb5d117d0af1311c65030671cd56eb987aa'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
