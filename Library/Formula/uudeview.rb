require 'formula'

class Uudeview < Formula
  homepage 'http://www.fpx.de/fp/Software/UUDeview/'
  url 'http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz'
  md5 '0161abaec3658095044601eae82bbc5b'

  def install
    args = ["--disable-tcl",
            "--mandir=#{man}",
            "--prefix=#{prefix}" ]

    system "./configure", *args
    system "make install"
  end

  def test
    system "uudeview -V"
  end
end
