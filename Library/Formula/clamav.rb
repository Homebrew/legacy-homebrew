require "formula"

class Clamav < Formula
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/0.98/clamav-0.98.1.tar.gz"
  sha1 "9f04c0e81463c36f7e58d18f16d1b88f3332dcb8"

  skip_clean "share"

  # Upstream patch for clang compatibility
  # https://bugzilla.clamav.net/show_bug.cgi?id=10757
  patch :p0 do
    url "https://trac.macports.org/export/119480/trunk/dports/sysutils/clamav/files/patch-libclamav-LoopInfo.h.diff"
    sha1 "647bfdd878a8db4b2a7af42c9887b1ae36c5e8de"
  end

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
