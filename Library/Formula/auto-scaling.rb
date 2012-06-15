require 'formula'

class AutoScaling < AmazonWebServicesFormula
  version  '1.0.61.0'
  homepage 'http://aws.amazon.com/developertools/2535'
  url      'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip'
  md5      '87a799204526e70939378bba8e0d83e9'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_AUTO_SCALING_HOME"
  end
end
