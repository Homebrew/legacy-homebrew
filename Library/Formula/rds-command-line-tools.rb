class RdsCommandLineTools < Formula
  desc "Amazon RDS command-line toolkit"
  homepage "https://aws.amazon.com/developertools/2928"
  url "https://s3.amazonaws.com/rds-downloads/RDSCli-1.19.004.zip"
  sha256 "298c15ccd04bd91f1be457645d233455364992e7dd27e09c48230fbc20b5950c"

  depends_on :java

  def install
    env = Language::Java.java_home_env.merge(:AWS_RDS_HOME => libexec)
    rm Dir["bin/*.cmd"] # Remove Windows versions
    etc.install "credential-file-path.template"
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
      Before you can use these tools you must export a variable to your $SHELL.
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
