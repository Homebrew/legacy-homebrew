require 'formula'

class AutoScaling < AmazonWebServicesFormula
  version  '1.0.49.1'
  homepage 'http://aws.amazon.com/developertools/2535'
  url      'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip'
  md5      '9d94f533743c5e9c65dd76f69666e739'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_AUTO_SCALING_HOME"
  end
end
