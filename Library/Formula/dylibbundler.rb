require 'formula'

class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for OS X"
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/macdylibbundler/macdylibbundler/0.4.4/dylibbundler-0.4.4.zip'
  sha1 '8d120bababc5218927447cf7fec57abf5d093ff6'

  bottle do
    cellar :any
    revision 1
    sha1 "7796af4a80af52b2cda87f9a6af74919811cddb4" => :yosemite
    sha1 "af56868cede7747f2559320659654e017cb0144a" => :mavericks
    sha1 "81c315d6fbaea3b56ba78e967953f3f8a11d08ec" => :mountain_lion
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
