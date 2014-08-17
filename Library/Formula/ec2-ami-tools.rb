require 'formula'

class Ec2AmiTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/368'
  url 'http://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.3.zip'
  sha1 'a12a4b4cb9d602e70a51dcf0daad35b412828e4e'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end
end
