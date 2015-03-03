class AwsCfnTools < AmazonWebServicesFormula
  homepage "http://aws.amazon.com/developertools/AWS-CloudFormation/2555753788650372"
  url "https://s3.amazonaws.com/cloudformation-cli/AWSCloudFormation-cli.zip"
  version "1.0.12"
  sha1 "1d308682effb9366b95cf2abf501c464d29ee012"

  depends_on :java
  depends_on "ec2-api-tools"

  def install
    standard_install :env => { :AWS_CLOUDFORMATION_HOME => libexec }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfn-version")
  end
end
