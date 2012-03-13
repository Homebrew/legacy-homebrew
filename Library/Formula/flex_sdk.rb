require 'formula'

class FlexSdk < Formula
  url 'http://fpdownload.adobe.com/pub/flex/sdk/builds/flex3/flex_sdk_3.0.0.477A_mpl.zip'
  version '3.0A'
  homepage 'http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK'
  md5 '59131fceb024aad67e12115754df96d8'

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
