require 'formula'

# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage 'http://www.gnu.org/software/libtool/'
  url 'http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz'
  sha1 '22b71a8b5ce3ad86e1094e7285981cae10e6ff88'

  bottle do
    revision 1
    sha1 '3a025da1e80c2965f0eee2591fca225315f97290' => :mavericks
    sha1 'bd62a22ee51cceec5e359d33f6b19d217368166d' => :mountain_lion
    sha1 '0cf484aa89183c6b3228c0f156229c787f996f89' => :lion
  end

  if MacOS::Xcode.provides_autotools? or File.file? "/usr/bin/glibtoolize"
    keg_only "Xcode 4.2 and below provide glibtool."
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", 'execute', '/usr/bin/true'
  end
end
