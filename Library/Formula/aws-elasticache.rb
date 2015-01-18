class AwsElasticache < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/2310261897259567"
  url "https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-2014-09-30-1.12.000.zip"
  version "1.12.000"
  sha1 "aeed292beada4aabe7d88562af0f1353556c0767"

  depends_on "ec2-api-tools"

  def caveats
    standard_instructions "AWS_ELASTICACHE_HOME"
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    ENV["AWS_ELASTICACHE_HOME"] = libexec
    system "#{bin}/elasticache-version"
  end
end
