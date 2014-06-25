require "formula"

class Clamav < Formula
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.4.tar.gz"
  sha1 "f1003d04f34efb0aede05395d3c7cc22c944e4ef"
  
  head "https://github.com/vrtadmin/clamav-devel"

  skip_clean "share"

  def install
    (share/"clamav").mkpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--sysconfdir=#{etc}",
                          "--disable-zlib-vcheck",
                          "--with-zlib=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end
end
