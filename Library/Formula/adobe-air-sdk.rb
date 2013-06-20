require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://www.adobe.com/products/air/sdk/'
  url 'http://airdownload.adobe.com/air/mac/download/3.7/AdobeAIRSDK.tbz2'
  sha1 '55b5d2675ef9cf9b7868635d5be100348d908134'

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/adl'
    bin.write_exec_script libexec/'bin/adt'
  end
end
