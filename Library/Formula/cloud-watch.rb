require 'formula'

class CloudWatch < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2534'
  url 'http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip'
  version '1.0.20.0'
  sha1 'c3f5b856b3ff8e1ae06d0ad5db5dd27c214c4881'

  def install
    standard_install
  end

  def caveats
    s = standard_instructions "AWS_CLOUDWATCH_HOME"
    s += <<-EOS.undent
      export SERVICE_HOME="$AWS_CLOUDWATCH_HOME"
    EOS
    return s
  end
end
