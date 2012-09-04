require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.4/SaxonHE9-4-0-2J.zip"
  sha1 '7383d2504f45582f94c0d9c9ca2f4fa322fad7a1'
  version "9.4.0.2"

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/saxon9he.jar" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+'saxon').write shim_script('saxon')
  end
end
