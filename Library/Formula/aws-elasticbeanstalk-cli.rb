require 'formula'

class AwsElasticbeanstalkCli < Formula
  homepage 'http://aws.amazon.com/code/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.2.zip'
  sha1 'c02f1962814b557b0eff15cb2f651cd9cd89c7a0'

  def install
    # Remove incompatible versions
    rm_rf Dir['eb/windows']
    rm_rf Dir['eb/linux']
    rm_rf Dir['AWSDevTools/Windows']

    #installing in a less elegant way to work around this issue https://forums.aws.amazon.com/thread.jspa?messageID=400362
    libexec.install Dir['eb', 'AWSDevTools']
    bin.install_symlink "#{libexec}/eb/macosx/python2.7/eb"
  end

  def caveats; <<-EOS.undent
    This package contains an updated command line interface (CLI), called eb, for AWS Elastic Beanstalk.
    AWS Elastic Beanstalk provides easy application deployment and management utilizing various Amazon
    Web Services resources that are created on your behalf. Eb helps you create and deploy your application
    in minutes. To ensure it works run:

    eb --help

    Further information: http://aws.amazon.com/code/6752709412171743

    EOS
  end
end
