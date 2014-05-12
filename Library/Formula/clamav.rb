require "formula"

class Clamav < Formula
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.3.tar.gz"
  sha1 "32f0a0675f8023b20e1d19fe8592e330674d0551"

  head "https://github.com/vrtadmin/clamav-devel"

  skip_clean "share"

  def install
    (share/"clamav").mkpath

    args = %W{--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-zlib-vcheck
              --libdir=#{lib}
              --sysconfdir=#{etc}}
    args << "--with-zlib=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?

    system "./configure", *args
    system "make", "install"
  end
end
