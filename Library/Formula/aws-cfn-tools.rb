class AwsCfnTools < Formula
  desc "Client for Amazon CloudFormation web service"
  homepage "https://aws.amazon.com/developertools/AWS-CloudFormation/2555753788650372"
  url "https://s3.amazonaws.com/cloudformation-cli/AWSCloudFormation-cli.zip"
  version "1.0.12"
  sha256 "382e3e951833fd77235fae41c1742224d68bdf165e1ace4200ee88c01ac29a90"

  bottle :unneeded

  depends_on "ec2-api-tools"
  depends_on :java

  def install
    env = Language::Java.java_home_env.merge(:AWS_CLOUDFORMATION_HOME => libexec)
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
    assert_match version.to_s, shell_output("#{bin}/cfn-version")
  end
end
