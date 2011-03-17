require 'formula'

# Require ec2-api-tools to get the base class
require "#{File.dirname __FILE__}/ec2-api-tools.rb"

class AutoScaling <AmazonWebServicesFormula
  version  '1.0.33.1'
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2535&categoryID=251'
  url      'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2010-08-01.zip'
  md5      'e2cfe8820cd5906bf520cf6069d9b95d'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_AUTO_SCALING_HOME"
  end
end
