class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.6.tar.gz"
  sha256 "bcef14d875ff70b26dfc9e892f33bd3665e3d5d9b12eca0c4f2aae133aca981d"

  bottle do
    sha256 "3aa2ecea4e62124aa7dc53c38825964f1b3761cff9aafcb23ae939a800418cf0" => :yosemite
    sha256 "e0b072606de1568a970101a520cf0e12bf803a85342dc9a96fffec425dea27eb" => :mavericks
    sha256 "7107f40a8092357edd6d5c5dc9892ee590aedd08267a707cbad390d1090c8ca4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install"
  end
end
