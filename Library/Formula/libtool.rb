require 'formula'

# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage 'http://www.gnu.org/software/libtool/'
  url 'http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz'
  sha1 '22b71a8b5ce3ad86e1094e7285981cae10e6ff88'

  bottle do
    sha1 'c8505f4e25f567555e0794c4aa000228e50d4b47' => :mountain_lion
    sha1 'b8ed9137176e40333bb538cc464aa7da4456b8ed' => :lion
    sha1 '5ce78673209a022b06a0d3d97e755d95d3d8b137' => :snow_leopard
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
