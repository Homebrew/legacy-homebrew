require 'formula'

class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/code/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.6.3.zip'
  sha1 'c510df910b657d98ab7b86497a3f61f7616f935e'

  def install
    # Remove versions for other platforms.
    rm_rf %w{eb/windows eb/linux AWSDevTools/Windows}
    libexec.install %w{AWSDevTools api eb}
    bin.install_symlink libexec/"eb/macosx/python2.7/eb"
  end
end
