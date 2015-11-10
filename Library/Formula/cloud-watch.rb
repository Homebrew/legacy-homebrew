class CloudWatch < Formula
  desc "Amazon CloudWatch command-line Tool"
  homepage "https://aws.amazon.com/developertools/2534"
  url "https://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip"
  version "1.0.20.0"
  sha256 "7b241dc6b49ea2aafdeb66f859be9d30128fb0ab5833074f6596762c9bd84417"

  bottle :unneeded

  depends_on :java

  def install
    env = Language::Java.java_home_env
    env.merge! :AWS_CLOUDWATCH_HOME => libexec, :SERVICE_HOME => libexec
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
    assert_match /w.x.y.z/, shell_output("#{bin}/mon-version")
  end
end
