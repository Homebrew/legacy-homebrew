require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.3/saxonhe9-3-0-5j.zip"
  md5 "a940c252e1ae386a5f9949ace75e4ea6"
  version "9.3.0.5"

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
