require 'formula'

class AwsElasticache < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2310261897259567'
  url 'https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-2012-03-09-1.6.001.zip'
  version '1.6.001'
  sha1 '926ad40c8de4148ba14d3ea472cc56cbf445fc36'

  depends_on 'ec2-api-tools'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_ELASTICACHE_HOME"
  end
end
