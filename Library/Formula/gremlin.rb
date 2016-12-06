require 'formula'

class Gremlin < Formula
  url 'https://github.com/downloads/tinkerpop/gremlin/gremlin-1.3.zip'
  homepage 'http://gremlin.tinkerpop.com/'
  md5 'c524ee20e119c3b6059cfd0b7873d94c'

  def install
    inreplace "gremlin.sh", '`dirname $0`', prefix
    system "mv gremlin.sh gremlin"
    system "rm gremlin.bat"
    bin.install "gremlin"
    prefix.install Dir['*']
  end
end
