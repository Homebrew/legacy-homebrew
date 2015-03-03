class Ec2AmiTools < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/368"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.6.zip"
  sha1 "cb1a0e807e6e4e473a5a462633cb9990ec851093"

  depends_on :java

  def install
    standard_install :env => { :EC2_AMITOOL_HOME => libexec }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ec2-ami-tools-version")
  end
end
