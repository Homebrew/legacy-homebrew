require 'formula'

class Ec2AmiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/368'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.4.0.9.zip'
  sha1 '96583c42b999ce64510fb721af1780719a7f0b34'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end
end
