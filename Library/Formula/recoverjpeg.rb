require 'formula'

class Recoverjpeg < Formula
  homepage 'http://www.rfc1149.net/devel/recoverjpeg.html'
  url 'https://github.com/downloads/samueltardieu/recoverjpeg/recoverjpeg-2.1.1.tar.gz'
  sha1 '0703ade03a735e2538c9ab87a160edf4bd388b8d'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
