require 'formula'

class Eina < Formula
  url 'http://download.enlightenment.org/releases/eina-1.0.1.tar.gz'
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  md5 'd302a5b981d8e140e64d2943c5f41bdc'
  depends_on 'pkg-config'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
