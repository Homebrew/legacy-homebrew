require 'formula'

class Recoverjpeg < Formula
  homepage 'http://www.rfc1149.net/devel/recoverjpeg.html'
  url 'http://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.3.tar.gz'
  sha1 'ed16b9852d85d7a07710d1ca41a03427642f3f38'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
