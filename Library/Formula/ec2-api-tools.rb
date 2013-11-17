require 'formula'

class Ec2ApiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/351'
  url 'http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip&token=A80325AA4DAB186C80828ED5138633E3F49160D9'
  sha1 'eb0732df59a2ad2c1ad3fa5839e846b69afad697'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_HOME"
  end
end
