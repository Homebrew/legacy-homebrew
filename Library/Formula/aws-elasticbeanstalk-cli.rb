require 'formula'

class AwsElasticbeanstalkCli < Formula
  homepage 'http://aws.amazon.com/code/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.2.zip'
  sha1 'c02f1962814b557b0eff15cb2f651cd9cd89c7a0'

  def install
    lib.install Dir["eb/macosx/python2.7/lib/*"]
    prefix.install Dir["eb/macosx/python2.7/scli"]
    prefix.install "eb/macosx/python2.7/eb"
    prefix.install "eb/macosx/python2.7/ca-bundle.crt"
    prefix.install "eb/macosx/python2.7/certifi.py"
    prefix.install "eb/macosx/python2.7/logconfig.json"
    bin.install_symlink "#{prefix}/eb"
  end

  def caveats
   <<-EOS.undent

      To check that your setup works properly, run the following command:
        eb --help

    EOS
  end

end
