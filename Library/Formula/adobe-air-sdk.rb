require 'formula'

class AdobeAirSdk < Formula
  url 'http://airdownload.adobe.com/air/mac/download/3.1/AdobeAIRSDK.tbz2'
  homepage 'http://www.adobe.com/products/air/sdk/'
  md5 'f2137a34888ce71574da87e0cc3b7b06'
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
