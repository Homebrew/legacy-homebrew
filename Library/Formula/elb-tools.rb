class ElbTools < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/2536"
  url "https://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip"
  version "1.0.35.0"
  sha1 "976f885c8a437183b2bb0c8127375e5f6371f498"

  depends_on "ec2-api-tools"

  def caveats
    standard_instructions "AWS_ELB_HOME"
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    ENV["AWS_ELB_HOME"] = libexec
    assert_match version.to_s, shell_output("#{bin}/elb-version")
  end
end
