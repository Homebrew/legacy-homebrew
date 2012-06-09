require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://www.adobe.com/products/air/sdk/'
  url 'http://airdownload.adobe.com/air/mac/download/3.3/AdobeAIRSDK.tbz2'
  sha1 '95fab877991fa749436d695cd612f7f4abfa7ee0'
  version '3.3'

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
