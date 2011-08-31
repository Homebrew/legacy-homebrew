require 'formula'

class AdobeAirSdk < Formula
  url 'http://airdownload.adobe.com/air/mac/download/2.7/AdobeAIRSDK.tbz2'
  homepage 'http://www.adobe.com/products/air/sdk/'
  md5 'f93c8a540a6db24509b4fbaddf2f1770'
  version '2.7'

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
