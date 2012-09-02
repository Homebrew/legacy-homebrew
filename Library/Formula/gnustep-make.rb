require 'formula'

class GnustepMake < Formula
  homepage 'http://gnustep.org'
  url 'http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.2.tar.gz'
  sha1 '3f85cb25f4f7fd35cdcbd8d948a2673c84c605ff'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-config-file=#{prefix}/etc/GNUstep.conf", "--enable-native-objc-exceptions"
    system "make install"
  end

  def test
    system "true"
  end

  def caveats; <<-EOS.undent
    To use GNUStep-make, you need to source it.
    It is suggested you add the following line to your .profile
      source #{prefix}/Library/GNUstep/Makefiles/GNUstep.sh
    EOS
  end
end
