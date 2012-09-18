require 'formula'

class Abcmidi < Formula
  homepage 'http://www.ifdo.ca/~seymour/runabc/top.html'
  url 'http://www.ifdo.ca/~seymour/runabc/abcMIDI-2012-08-08.zip'
  version '2012-08-08'
  sha1 '004f09087c56fe00c6024de4b292111515f1df16'

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
