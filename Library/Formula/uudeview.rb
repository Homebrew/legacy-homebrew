require 'formula'

class Uudeview < Formula
  homepage 'http://www.fpx.de/fp/Software/UUDeview/'
  url 'http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz'
  md5 '0161abaec3658095044601eae82bbc5b'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}","--disable-tcl"
    system "make install"
  end

  def test
    system "#{bin}/uudeview -V"
  end
end
