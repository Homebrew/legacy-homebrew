require "formula"

class Clamav < Formula
  homepage "http://www.clamav.net/"
  head "https://github.com/vrtadmin/clamav-devel"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.4.tar.gz"
  sha1 "f1003d04f34efb0aede05395d3c7cc22c944e4ef"

  bottle do
    sha1 "4ed3b47b0b8e41861ef6d96966e9c562dd2a4a40" => :mavericks
    sha1 "e100c4726571fa7b03b6e62188bb0c8ccd06394e" => :mountain_lion
    sha1 "4d2596ed31086455d7e87bade419589da46a3ef3" => :lion
  end

  skip_clean "share/clamav"

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
