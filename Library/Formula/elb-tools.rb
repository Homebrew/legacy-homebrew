require 'formula'

class ElbTools < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2536'
  url 'http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip'
  version '1.0.33.0'
  sha1 '4415660b6104b02f1f91ac7528a231ef7661d543'

  depends_on 'ec2-api-tools'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_ELB_HOME"
  end
end
