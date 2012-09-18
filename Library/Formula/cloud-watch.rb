require 'formula'

class CloudWatch < AmazonWebServicesFormula
  version  '1.0.12.1'
  homepage 'http://aws.amazon.com/developertools/2534'
  url      'http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip'
  sha1 'e9e1b4c31531242fae26fabc18acc88351d6be1b'

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
