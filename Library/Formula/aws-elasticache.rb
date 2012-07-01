require 'formula'

class AwsElasticache < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2310261897259567'
  url 'https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-2012-03-09-1.6.000.zip'
  version '1.6.0'
  md5 'd5d5f6ee58105b0d994bde4ff120b867'

  depends_on 'ec2-api-tools'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_ELASTICACHE_HOME"
  end
end
