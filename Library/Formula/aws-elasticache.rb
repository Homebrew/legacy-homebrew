require 'formula'

class AwsElasticache < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2310261897259567'
  url 'https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-2013-06-15-1.9.000.zip'
  version '1.9.000'
  sha1 'c8962cc2ea22f88883b38cda2674d1befbed1b71'

  depends_on 'ec2-api-tools'

  def install
    rm Dir['bin/*.cmd'] # Remove Windows command files
    libexec.install "bin", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bin/'service').unlink # Don't keep this symlink
  end

  def caveats
    standard_instructions "AWS_ELASTICACHE_HOME", libexec
  end
end
