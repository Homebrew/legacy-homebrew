require 'formula'

class ElbTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2536'
  url 'http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip'
  version '1.0.34.0'
  sha1 '3d2c30a8fe8294a51463aac6ec926b908cc11f4a'

  depends_on 'ec2-api-tools'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_ELB_HOME"
  end
end
