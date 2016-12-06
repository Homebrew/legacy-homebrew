require 'formula'

class Libhpdf < Formula
  homepage 'http://libharu.org'
  url 'http://libharu.org/files/libhpdf-2.3.0RC2.tar.bz2'
  sha1 '96907e28c3e8bb6302d4e47db635e05b93dceac8'

  depends_on :libpng

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}"
    system 'make install'
  end
end
