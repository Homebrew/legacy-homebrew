require 'formula'

class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/code/AWS-Elastic-Beanstalk/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.3.zip'
  sha1 '7fdcdefa906b498b5a9c964b8c3d2aabcad406e6'

  def install
    # Remove versions for other platforms.
    rm_rf Dir['eb/windows']
    rm_rf Dir['eb/linux']
    rm_rf Dir['AWSDevTools/Windows']

    libexec.install %w{AWSDevTools api eb}
    bin.install_symlink libexec/"eb/macosx/python2.7/eb"
  end
end
