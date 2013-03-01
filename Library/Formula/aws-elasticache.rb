require 'formula'

class AwsElasticache < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2310261897259567'
  url 'https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-2012-08-01-1.7.000.zip'
  version '1.7.000'
  sha1 '5a46ab1e769b32f5de16f7b8d080865dd81750f9'

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
