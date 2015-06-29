class RdsCommandLineTools < Formula
  desc "Amazon RDS command-line toolkit"
  homepage "https://aws.amazon.com/developertools/2928"
  url "https://s3.amazonaws.com/rds-downloads/RDSCli-1.19.004.zip"
  sha1 "33be9c7e9d58d4bdd5ffa468b159265bd17cf2fa"

  depends_on :java

  def install
    env = Language::Java.java_home_env.merge(:AWS_RDS_HOME => libexec)
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

      To check that your setup works properly, run the following command:
        rds-describe-db-instances --headers
      You should see a header line. If you have database instances already configured,
      you will see a description line for each database instance.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rds-version")
  end
end
