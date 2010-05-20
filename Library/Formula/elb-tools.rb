require 'formula'

# Require ec2-api-tools to get the base class
require "#{File.dirname __FILE__}/ec2-api-tools.rb"

class ElbTools <AmazonWebServicesFormula
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?categoryID=251&externalID=2536'
  url 'http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip'
  version '1.0.9.3'
  md5 'ffe5cacb93f2f281996fbe8b501da5ac'

  def install
    rm "bin/.COMPONENT_CACHED"
    standard_install
  end

  def caveats
    standard_instructions "AWS_ELB_HOME"
  end
end
