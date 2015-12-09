class AwsElasticache < Formula
  desc "Client for Amazon ElastiCache web service"
  homepage "https://aws.amazon.com/developertools/2310261897259567"
  url "https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-2014-09-30-1.12.000.zip"
  version "1.12.000"
  sha256 "0aee0849a78c8129ed16e99706dde34972c02ed1846e70b76a1e21a133d9648f"

  bottle :unneeded

  depends_on "ec2-api-tools"
  depends_on :java

  def install
    env = Language::Java.java_home_env.merge(:AWS_ELASTICACHE_HOME => libexec)
    rm Dir["bin/*.cmd"] # Remove Windows versions
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?
      basename = file.basename
      next if basename.to_s == "service"
      (bin/basename).write_env_script file, env
    end
  end

  def caveats
    <<-EOS.undent
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    system "#{bin}/elasticache-version"
  end
end
