require 'formula'

class Lcrack < Formula
  url 'http://usuarios.multimania.es/reinob/lcrack/lcrack-20040914.tar.gz'
  homepage 'http://usuarios.multimania.es/reinob/'
  md5 '06494778de3ad697fe65af1dc8c72481'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "lcrack"
  end
end
