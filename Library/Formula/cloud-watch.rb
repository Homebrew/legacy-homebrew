require 'formula'

class CloudWatch < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2534'
  url 'http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip'
  version '1.0.13.4'
  sha1 '24f4cbe8554790b7abcc3c037172ab2efecae1af'

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
