require 'formula'

class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/code/AWS-Elastic-Beanstalk/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.4.0.zip'
  sha1 'dedd4bbdd037c52ab417f80170f3109319f0dce2'

  def install
    # Remove versions for other platforms.
    rm_rf Dir['eb/windows']
    rm_rf Dir['eb/linux']
    rm_rf Dir['AWSDevTools/Windows']

    libexec.install %w{AWSDevTools api eb}
    bin.install_symlink libexec/"eb/macosx/python2.7/eb"
  end
end
