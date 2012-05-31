require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://www.adobe.com/products/air/sdk/'
  url 'http://airdownload.adobe.com/air/mac/download/3.1/AdobeAIRSDK.tbz2'
  md5 'f2137a34888ce71574da87e0cc3b7b06'
  version '3.1'

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
