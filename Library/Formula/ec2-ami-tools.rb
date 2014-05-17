require 'formula'

class Ec2AmiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/368'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.2.zip'
  sha1 '1ee8ec20717426d4f516422b63107bde1421a085'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end
end
