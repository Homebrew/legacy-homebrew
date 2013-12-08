require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.6.12.0.zip'
  sha1 'eb0732df59a2ad2c1ad3fa5839e846b69afad697'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
