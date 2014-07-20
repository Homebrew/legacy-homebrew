require 'formula'

class Dylibbundler < Formula
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/macdylibbundler/macdylibbundler/0.4.4/dylibbundler-0.4.4.zip'
  sha1 '8d120bababc5218927447cf7fec57abf5d093ff6'

  bottle do
    cellar :any
    sha1 "9cb552b5a5aa59bc91d5d30957ddced29f1a3493" => :mavericks
    sha1 "169b43be109b00d73d5f67fc10625eb7d3b0fb38" => :mountain_lion
    sha1 "d2c32949637f3ca23cfe51bb2740024dfabf7673" => :lion
  end

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
