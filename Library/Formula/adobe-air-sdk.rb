require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://www.adobe.com/products/air/sdk/'
  url 'http://airdownload.adobe.com/air/mac/download/3.8/AdobeAIRSDK.tbz2'
  sha1 '30d090d13da218934da8e9327be99cd64bbaff6e'

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/adl'
    bin.write_exec_script libexec/'bin/adt'
  end
end
