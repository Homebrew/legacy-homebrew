require 'formula'

class Dylibbundler < Formula
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'http://sourceforge.net/projects/macdylibbundler/files/macdylibbundler/0.4.3/dylibbundler-0.4.3.zip'
  sha1 '9335f16ea90a375151707b03e59a7c5de41c39a9'

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
