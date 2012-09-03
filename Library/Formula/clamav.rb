require 'formula'

class Clamav < Formula
  homepage 'http://www.clamav.net/'
  url 'http://downloads.sourceforge.net/clamav/clamav-0.97.5.tar.gz'
  sha1 '1bb317ead4a1a677a9a11a063fc35a63f22309e9'

  def install
    args = %W{--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-zlib-vcheck
              --libdir=#{lib}}
    args << "--with-zlib=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?

    system "./configure", *args
    system "make install"
  end
end
