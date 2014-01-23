require 'formula'

class Clamav < Formula
  homepage 'http://www.clamav.net/'
  url 'http://downloads.sourceforge.net/clamav/0.98/clamav-0.98.1.tar.gz'
  sha1 '9f04c0e81463c36f7e58d18f16d1b88f3332dcb8'

  skip_clean 'share'

  def install
    (share/'clamav').mkpath

    args = %W{--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-zlib-vcheck
              --libdir=#{lib}
              --sysconfdir=#{etc}}
    args << "--with-zlib=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?

    system "./configure", *args
    system "make install"
  end
end
