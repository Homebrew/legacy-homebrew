require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://www.adobe.com/products/air/sdk/'
  url 'http://airdownload.adobe.com/air/mac/download/3.4/AdobeAIRSDK.tbz2'
  sha1 '3bc90f619d9f1620187538b6f591675c7d6011d5'
  version '3.4'

  def startup_script name
    (bin+name).write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']
    startup_script("adl")
    startup_script("adt")
  end
end
