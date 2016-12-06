require 'formula'

class AwsElasticbeanstalkCli < Formula
  homepage 'http://aws.amazon.com/code/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.2.zip'
  sha1 'c02f1962814b557b0eff15cb2f651cd9cd89c7a0'

  def install
    # Remove Windows versions
    rm_rf Dir['eb/windows']
    rm_rf Dir['AWSDevTools/Windows']

    # Copy everything to prefix dir
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    The ElasticBeanstalk CLI app 'eb' can be run on Linux and Mac OS X.
    You need to alias the appropriate one yourself:

    For Linux, add these aliases to your shell .profile:
      alias eb="python2.7 #{prefix}/eb/linux/python2.7/eb"
      alias eb3="python3.0 #{prefix}/eb/linux/python3/eb"

    For Mac OS X, add these aliases:
      alias eb="python2.7 #{prefix}/eb/macosx/python2.7/eb"
      alias eb3="python3.0 #{prefix}/eb/macosx/python3/eb"
    EOS
  end
end
