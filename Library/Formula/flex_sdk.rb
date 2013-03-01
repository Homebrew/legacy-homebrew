require 'formula'

class FlexSdk < Formula
  homepage 'http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK'
  url 'http://fpdownload.adobe.com/pub/flex/sdk/builds/flex4.6/flex_sdk_4.6.0.23201_mpl.zip'
  version '4.6.0.23201'
  sha1 '86f2cacd0c1927c845a770c02f33fe4a0a3375f4'

  def install
    libexec.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To use the SDK you will need to:

    (a) add the bin folder to your $PATH:
      #{libexec}/bin

    (b) set $FLEX_HOME:
      export FLEX_HOME=#{libexec}

    (c) add the tasks jar to ANT:
      mkdir -p ~/.ant/lib
      ln -s #{libexec}/ant/lib/flexTasks.jar ~/.ant/lib
    EOS
  end
end
