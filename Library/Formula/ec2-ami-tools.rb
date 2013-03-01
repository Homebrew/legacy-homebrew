require 'formula'

class Ec2AmiTools < AmazonWebServicesFormula
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368'
  url 'http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-1.4.0.7.zip'
  sha1 '9af4e621860486d491c184014c1d955a82d834b9'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end
end
