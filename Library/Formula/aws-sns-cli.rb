class AwsSnsCli < Formula
  desc "Client for Amazon Simple Notification web service"
  homepage "https://aws.amazon.com/developertools/3688"
  url "https://sns-public-resources.s3.amazonaws.com/SimpleNotificationServiceCli-2010-03-31.zip"
  # The version in the tarball is the API version; this is the tool version
  version "2013-09-27"
  sha256 "c14adade30bf366f7d95d19d177babd33669dbd0e4b46f2c81304723776d382f"

  depends_on :java

  def install
    env = Language::Java.java_home_env.merge(:AWS_SNS_HOME => libexec)
    rm Dir["bin/*.cmd"] # Remove Windows versions
    chmod 0755, Dir["bin/*"]
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
    assert_match /w.x.y.z/, shell_output("#{bin}/sns-version")
  end
end
