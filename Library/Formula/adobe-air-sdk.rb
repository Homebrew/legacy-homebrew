require 'formula'

class AdobeAirSdk <Formula
  url 'http://airdownload.adobe.com/air/mac/download/latest/AdobeAIRSDK.tbz2'
  homepage 'http://www.adobe.com/products/air/sdk/'
  md5 'e46e1da07f01611d905b6ec89b8b1331'
  version '2.5'

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
