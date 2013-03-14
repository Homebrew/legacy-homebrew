require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://www.adobe.com/products/air/sdk/'
  url 'http://airdownload.adobe.com/air/mac/download/3.6/AdobeAIRSDK.tbz2'
  sha1 'c43b0b100a46b7f304a1b213664b3bf573721b85'

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/adl'
    bin.write_exec_script libexec/'bin/adt'
  end
end
