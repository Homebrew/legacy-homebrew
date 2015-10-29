class ElbTools < Formula
  desc "Client interface to the Amazon Elastic Load Balancing web service"
  homepage "https://aws.amazon.com/developertools/2536"
  url "https://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip"
  version "1.0.35.0"
  sha256 "31d9aa0ca579c270f8e3579f967b6048bc070802b7b41a30a9fa090fbffba62b"

  bottle :unneeded

  depends_on "ec2-api-tools"
  depends_on :java

  def install
    env = Language::Java.java_home_env.merge(:AWS_ELB_HOME => libexec)
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
    assert_match version.to_s, shell_output("#{bin}/elb-version")
  end
end
