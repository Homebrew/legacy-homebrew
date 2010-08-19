require 'formula'

# Require ec2-api-tools to get the base class
require "#{File.dirname __FILE__}/ec2-api-tools.rb"

class Ec2AmiTools <AmazonWebServicesFormula
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368'
  url 'http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-1.3-45758.zip'
  md5 'b3fd0dd779277ba40f0f234bfa309135'

  def install
    standard_install
  end

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end
end
