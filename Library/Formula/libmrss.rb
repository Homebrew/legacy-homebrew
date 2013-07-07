require 'formula'

class Libmrss < Formula
  homepage 'http://www.autistici.org/bakunin/libmrss/'
  url 'http://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz'
  sha1 '3723b0f41151873de11eb56bb3743a4f72d446ce'

  depends_on 'pkg-config' => :build
  depends_on 'libnxml'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
