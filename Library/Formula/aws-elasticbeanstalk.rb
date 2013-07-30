require 'formula'

class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/code/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.5.1.zip'
  sha1 'ad55ba660ff6852742ec1066abba506378049078'
  version '2.5.1'

  def install
    # Remove versions for other platforms.
    rm_rf Dir['eb/windows']
    rm_rf Dir['eb/linux']
    rm_rf Dir['AWSDevTools/Windows']

    libexec.install %w{AWSDevTools api eb}
    bin.install_symlink libexec/"eb/macosx/python2.7/eb"
  end
end
