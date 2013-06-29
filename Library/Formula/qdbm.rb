require 'formula'

class Qdbm < Formula
  homepage 'http://fallabs.com/qdbm'
  url 'http://fallabs.com/qdbm/qdbm-1.8.78.tar.gz'
  sha1 '8c2ab938c2dad8067c29b0aa93efc6389f0e7076'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-bzip",
                          "--enable-zlib",
                          "--enable-iconv"
    system "make mac"
    system "make install-mac"
  end
end
