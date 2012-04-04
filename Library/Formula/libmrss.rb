require 'formula'

class Libmrss < Formula
  homepage 'http://www.autistici.org/bakunin/libmrss/'
  url 'http://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz'
  md5 'a6f66b72898d27270e3a68007f90d62b'

  depends_on 'pkg-config' => :build
  depends_on 'libnxml'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
