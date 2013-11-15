require 'formula'

class Dylibbundler < Formula
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/macdylibbundler/macdylibbundler/0.4.4/dylibbundler-0.4.4.zip'
  sha1 '1b9a01b60bf345fc599c12ca59ef4fd94a277de4'

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
