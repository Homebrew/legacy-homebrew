class GnustepMake < Formula
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.6.tar.gz"
  sha256 "bcef14d875ff70b26dfc9e892f33bd3665e3d5d9b12eca0c4f2aae133aca981d"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install"
  end
end
