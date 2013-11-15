require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://adobe.com/products/air/sdk'

  option 'with-compiler', 'Grab the version with the new compiler (for non-Flex users).'

  if build.with? 'compiler'
    sha1 '1334fad165bab05f3abe0579ed1776e58c8da43e'
    url 'http://airdownload.adobe.com/air/mac/download/3.9/AIRSDK_Compiler.tbz2'
  else
    sha1 '715da9ad8f3bc7a61dcc54835084cbc7b9a92d66'
    url 'http://airdownload.adobe.com/air/mac/download/3.9/AdobeAIRSDK.tbz2'
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
