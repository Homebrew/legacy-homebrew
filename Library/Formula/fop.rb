require 'formula'

class Fop < Formula
  homepage "http://xmlgraphics.apache.org/fop/index.html"
  url "http://mirrors.ibiblio.org/pub/mirrors/apache/xmlgraphics/fop/binaries/fop-1.0-bin.tar.gz"
  md5 "3186f93a314bdcb710bd7cb02d80404c"

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
