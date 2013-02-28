require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://www.adobe.com/products/air/sdk/'
  url 'http://download.macromedia.com/air/mac/download/3.6/AIRSDK_Compiler.tbz2'
  sha1 '669fa27502df8939a513ced7636b974e1e753302'

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
