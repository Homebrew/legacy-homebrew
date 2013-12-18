require 'formula'

class Clamav < Formula
  homepage 'http://www.clamav.net/'
  url 'http://downloads.sourceforge.net/clamav/0.98/clamav-0.98.tar.gz'
  sha1 '1e6a7284721387646c713a8d32fa8b5a897985db'

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
