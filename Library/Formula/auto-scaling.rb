require 'formula'

class AutoScaling < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2535'
  url 'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip'
  version  '1.0.61.1'
  sha1 'ceae80f368123d47d543ce0a7aae2a048a23b232'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_AUTO_SCALING_HOME"
  end
end
