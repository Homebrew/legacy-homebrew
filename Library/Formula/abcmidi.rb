require 'formula'

class Abcmidi < Formula
  homepage 'http://www.ifdo.ca/~seymour/runabc/top.html'
  url 'http://www.ifdo.ca/~seymour/runabc/abcMIDI-2012-12-25.zip'
  version '2012-12-25'
  sha1 '5c07824fab43e4057be671dc94afa4335cde05f1'

  def install
    # configure --prefix flag does not work properly (value is added to path twice).
    # abcmidi author is notified. 2012-06-20
    system "./configure", "--disable-debug", "--prefix="
    system "make", "install", "DESTDIR=#{prefix}"
    man.install prefix/'man/man1'
  end

  def test
    system "#{bin}/abc2midi"
  end
end
