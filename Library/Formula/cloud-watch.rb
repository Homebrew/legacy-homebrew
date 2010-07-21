require 'formula'

# Require ec2-api-tools to get the base class
require "#{File.dirname __FILE__}/ec2-api-tools.rb"

class CloudWatch <AmazonWebServicesFormula
  version  '1.0.2.3'
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2534&categoryID=251'
  url      'http://ec2-downloads.s3.amazonaws.com/CloudWatch-2009-05-15.zip'
  md5      '25cd175dca3e5fb51d970a2beb040dd4'
  aka      'aws-mon'
  
  def install
    standard_install
  end

  def caveats
    s = standard_instructions "AWS_CLOUDWATCH_HOME"
    s += <<-EOS.undent
      export SERVICE_HOME="$AWS_CLOUDWATCH_HOME"
    EOS
    return s
  end
end