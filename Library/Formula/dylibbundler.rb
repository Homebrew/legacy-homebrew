require 'formula'

class Dylibbundler < Formula
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'http://sourceforge.net/projects/macdylibbundler/files/macdylibbundler/0.4.2/dylibbundler-0.4.2.zip'
  sha1 '7cd65413ed250a42a3428e34d624e3141c173ab4'

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
