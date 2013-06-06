require 'formula'

class AwsSnsCli < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/3688'
  url 'http://sns-public-resources.s3.amazonaws.com/SimpleNotificationServiceCli-2010-03-31.zip'
  # The version in the tarball is the API version; this is the tool version
  version '2012-03-31'
  sha1 'b7b2c1dc0e604b3fb4056845eeea03a51bc6cd7b'

  def install
    rm Dir['bin/*.cmd'] # Remove Windows versions

    # There is a "service" binary, which of course will conflict with any number
    # other brews that have a generically named tool. So don't just blindly
    # install bin to the prefix.
    jars = prefix/'jars'
    jars.install "bin", "lib"
    system "chmod +x #{jars}/bin/*"
    bin.install_symlink Dir["#{jars}/bin/sns-*"]
  end

  def caveats
    standard_instructions "AWS_SNS_HOME"
  end
end
