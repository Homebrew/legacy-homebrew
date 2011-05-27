require 'formula'

class AdobeAirSdk < Formula
  url 'http://airdownload.adobe.com/air/mac/download/2.6/AdobeAIRSDK.tbz2'
  homepage 'http://www.adobe.com/products/air/sdk/'
  md5 '0101d52ac13baa9508f1ebee0fb275ad'
  version '2.6'

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
