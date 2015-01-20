class Ec2AmiTools < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/368"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.3.zip"
  sha1 "a12a4b4cb9d602e70a51dcf0daad35b412828e4e"

  def caveats
    standard_instructions "EC2_AMITOOL_HOME"
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    ENV["EC2_AMITOOL_HOME"] = libexec
    assert_match version.to_s, shell_output("#{bin}/ec2-ami-tools-version")
  end
end
