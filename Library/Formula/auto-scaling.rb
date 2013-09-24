require 'formula'

class AutoScaling < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2535'
  url 'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip'
  version  '1.0.61.3'
  sha1 '8c2a1ad226c362622a599cf481fd3fe67204625c'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_AUTO_SCALING_HOME"
  end
end
