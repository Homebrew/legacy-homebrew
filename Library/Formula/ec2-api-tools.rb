class Ec2ApiTools < Formula
  desc "Client interface to the Amazon EC2 web service"
  homepage "https://aws.amazon.com/developertools/351"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.7.4.0.zip"
  sha256 "4808c712944c8e7b806cd3b4812508036ae3de565edec35964a9e88bb42ab728"

  bottle :unneeded

  depends_on :java

  def install
    env = Language::Java.java_home_env.merge(:EC2_HOME => libexec)
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
    assert_match version.to_s, shell_output("#{bin}/ec2-version")
  end
end
