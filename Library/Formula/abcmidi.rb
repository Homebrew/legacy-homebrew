require 'formula'

class Abcmidi < Formula
  homepage 'http://www.ifdo.ca/~seymour/runabc/top.html'
  url 'http://www.ifdo.ca/~seymour/runabc/abcMIDI-2012-06-04.zip'
  version '2012-06-04'
  sha1 '203252c50b556345a409d2bb7e031ccb0df09357'

  def install
    # configure --prefix flag does not work properly (value is added to path twice).
    # abcmidi author is notified. 2012-06-20
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=", "--mandir=#{man}"
    system "make install DESTDIR=#{prefix}"
  end

  def test
    system "abc2midi"
  end
end
