require 'formula'

class Recoverjpeg < Formula
  homepage 'http://www.rfc1149.net/devel/recoverjpeg.html'
  url 'http://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.2.3.tar.gz'
  sha1 '212555b4addaebab3c3559e43e51815cc090183e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
