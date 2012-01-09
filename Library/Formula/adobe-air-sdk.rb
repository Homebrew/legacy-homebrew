require 'formula'

class AdobeAirSdk < Formula
  url 'http://airdownload.adobe.com/air/mac/download/3.1/AdobeAIRSDK.tbz2'
  homepage 'http://www.adobe.com/products/air/sdk/'
  md5 '415cb4650f951c4ede9965ff3efed6dd'
  version '3.1'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
  end

  def install
    libexec.install Dir['*']

    bin.mkpath
    %w[adl adt].each do |tool|
      (bin+tool).write startup_script(tool)
    end
  end
end
