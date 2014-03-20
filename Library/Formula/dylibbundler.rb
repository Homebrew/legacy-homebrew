require 'formula'

class Dylibbundler < Formula
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/macdylibbundler/macdylibbundler/0.4.4/dylibbundler-0.4.4.zip'
  sha1 '8d120bababc5218927447cf7fec57abf5d093ff6'

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end

  def caveats; <<-EOS.undent
    Usage example:
      dylibbundler -od -b -x ./HelloWorld.app/Contents/MacOS/helloworld  -d ./HelloWorld.app/Contents/libs/
    EOS
  end
end
