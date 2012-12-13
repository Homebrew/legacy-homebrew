require 'formula'

class Dylibbundler < Formula
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'http://sourceforge.net/projects/macdylibbundler/files/macdylibbundler/0.4.1/dylibbundler0.4.1.zip'
  sha1 'ea80b57a487da3df3e3cc508573bf18268100464'

  def install
    system "make"
    bin.install "dylibbundler"
  end

  def test
    system "#{bin}/dylibbundler", "-h"
  end

  def caveats; <<-EOS.undent
    Usage example:
      dylibbundler -od -b -x ./HelloWorld.app/Contents/MacOS/helloworld  -d ./HelloWorld.app/Contents/libs/
    EOS
  end
end
