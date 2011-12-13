require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.4/SaxonHE9-4-0-1J.zip"
  md5 "c31d3664d04ea6583accd4131a516d72"
  version "9.4.0.1"

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      java -jar #{libexec}/saxon9he.jar "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+'saxon').write shim_script('saxon')
  end
end
