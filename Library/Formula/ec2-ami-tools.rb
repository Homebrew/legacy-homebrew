require 'formula'

class Ec2AmiTools < AmazonWebServicesFormula
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368'
  url 'http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-1.4.0.7.zip'
  md5 '9d315e7d7d8f5713b2349d3de2aec42b'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end
end
