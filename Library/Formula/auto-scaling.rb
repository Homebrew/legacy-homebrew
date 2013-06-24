require 'formula'

class AutoScaling < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/2535'
  url 'http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip'
  version  '1.0.61.2'
  sha1 '561b7b737b0ada420eeb044bf617cef628c9d894'

  def install
    standard_install
  end

  def caveats
    standard_instructions "AWS_AUTO_SCALING_HOME"
  end
end
