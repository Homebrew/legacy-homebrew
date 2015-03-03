class CloudWatch < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/2534"
  url "https://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip"
  version "1.0.20.0"
  sha1 "c3f5b856b3ff8e1ae06d0ad5db5dd27c214c4881"

  depends_on :java

  def install
    standard_install :env => { :AWS_CLOUDWATCH_HOME => libexec, :SERVICE_HOME => libexec }
  end

  test do
    assert_match /w.x.y.z/, shell_output("#{bin}/mon-version")
  end
end
