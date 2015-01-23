class Ec2ApiTools < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/351"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.7.3.0.zip"
  sha1 "c2a77b6c3b9fe05fdf4a126d03f8cd07791aaa50"

  def caveats
    standard_instructions "EC2_HOME"
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    ENV["EC2_HOME"] = libexec
    assert_match version.to_s, shell_output("#{bin}/ec2-version")
  end
end
