require 'formula'

class Lcrack < Formula
  url 'http://usuarios.multimania.es/reinob/lcrack/lcrack-20040914.tar.gz'
  homepage 'http://usuarios.multimania.es/reinob/'
  sha1 'd3b8f217f8ace5f4545060d15ce9f85a0daba17f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "lcrack"
  end
end
