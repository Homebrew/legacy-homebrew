require 'formula'

class Unafold < Formula
  url 'http://dinamelt.bioinfo.rpi.edu/download/unafold-3.8.tar.gz'
  homepage 'http://dinamelt.bioinfo.rpi.edu/unafold/'
  md5 'c1d473c1c4685b7ded51979d8fe4ce0b'

  depends_on 'gd'
  depends_on 'gnuplot'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
