require 'formula'

# Require ec2-api-tools to get the base class
require "#{File.dirname __FILE__}/ec2-api-tools.rb"

class ElbTools < AmazonWebServicesFormula
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?categoryID=251&externalID=2536'
  url 'http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip'
  version '1.0.12.0'
  md5 'e97939c0d5082f143cf3b716c0abeda7'

  depends_on 'ec2-api-tools'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_ELB_HOME"
  end
end
