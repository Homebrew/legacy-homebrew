class AutoScaling < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/2535"
  url "https://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip"
  version "1.0.61.6"
  sha1 "2e3aaaa2567f4dcafcedbfc05678270ab02ed341"

  depends_on :java

  def install
    standard_install :env => { :AWS_AUTO_SCALING_HOME => libexec }
  end

  def caveats
    s = super
    s += <<-EOS.undent

      See the website for more details:
      https://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/UsingTheCommandLineTools.html
    EOS
    s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/as-version")
  end
end
