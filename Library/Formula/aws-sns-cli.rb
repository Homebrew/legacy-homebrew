class AwsSnsCli < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/3688"
  url "https://sns-public-resources.s3.amazonaws.com/SimpleNotificationServiceCli-2010-03-31.zip"
  # The version in the tarball is the API version; this is the tool version
  version "2013-09-27"
  sha1 "192bd9e682f2b27a3c10f207f7a85c65dcaae471"

  depends_on :java

  def install
    chmod 0755, Dir["bin/*"]
    standard_install :env => { :AWS_SNS_HOME => libexec }
  end

  test do
    assert_match /w.x.y.z/, shell_output("#{bin}/sns-version")
  end
end
