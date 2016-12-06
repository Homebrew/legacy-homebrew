require 'formula'

class Recoverjpeg < Formula
  homepage 'http://www.rfc1149.net/devel/recoverjpeg.html'
  url 'https://github.com/downloads/samueltardieu/recoverjpeg/recoverjpeg-2.1.1.tar.gz'
  md5 '5aa6c4f1bca3889c07db1e8c5775cf0d'

  def install

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
