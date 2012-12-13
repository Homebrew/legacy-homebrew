require 'formula'

class Abcmidi < Formula
  homepage 'http://www.ifdo.ca/~seymour/runabc/top.html'
  url 'http://www.ifdo.ca/~seymour/runabc/abcMIDI-2012-11-03.zip'
  version '2012-11-03'
  sha1 'c173a6aa4be9869d030c8900615dd45792d5cdba'

  def install
    # configure --prefix flag does not work properly (value is added to path twice).
    # abcmidi author is notified. 2012-06-20
    system "./configure", "--disable-debug",
                          "--prefix="
    system "make install DESTDIR=#{prefix}"
    man.install prefix/'man/man1'
  end

  def test
    system "#{bin}/abc2midi"
  end
end
