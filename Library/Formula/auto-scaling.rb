require 'formula'

# Require ec2-api-tools to get the base class
require "#{File.dirname __FILE__}/ec2-api-tools.rb"

class AutoScaling <AmazonWebServicesFormula
  version  '1.0.9.0'
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2535&categoryID=251'
  url      'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2009-05-15.zip'
  md5      'a8410272127432d01d5f1a90d976b822'
  aka      'aws-as'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_AUTO_SCALING_HOME"
  end
end