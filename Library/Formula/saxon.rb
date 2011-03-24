require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.3/saxonhe9-3-0-4j.zip"
  md5 "9286c94c976109cbf23c226235a2e105"
  version "9.3.0.4"

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
