require 'formula'

class Fop <Formula
  homepage "http://xmlgraphics.apache.org/fop/index.html"
  url "http://mirrors.ibiblio.org/pub/mirrors/apache/xmlgraphics/fop/binaries/fop-0.95-bin.tar.gz"
  md5 "7af50bf58924dd22d71d22d8ad90b268"

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      #{libexec}/#{target} $*
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+'fop').write shim_script('fop')
  end
end
