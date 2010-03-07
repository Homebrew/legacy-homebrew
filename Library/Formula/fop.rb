require 'formula'

class Fop <Formula
  homepage "http://xmlgraphics.apache.org/fop/index.html"
  url "http://mirrors.ibiblio.org/pub/mirrors/apache/xmlgraphics/fop/binaries/fop-0.95-bin.tar.gz"
  md5 "7af50bf58924dd22d71d22d8ad90b268"
  aka 'apache-fop'

  def install
    prefix.install Dir["*"]
  end
end
