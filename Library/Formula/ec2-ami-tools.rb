require 'formula'

class Ec2AmiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/368'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.1.zip'
  sha1 '65deb85e452a3341ff12204db8eba0dcfd9db6a3'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end
end
