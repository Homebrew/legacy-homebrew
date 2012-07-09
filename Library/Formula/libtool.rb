require 'formula'

# Xcode 4.3 provides the Apple libtool
# This is not the same, but as a result we must install these as glibtool etc.

class Libtool < Formula
  homepage 'http://www.gnu.org/software/libtool/'
  url 'http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz'
  sha1 '22b71a8b5ce3ad86e1094e7285981cae10e6ff88'

  if MacOS.xcode_version.to_f < 4.3 or File.file? "/usr/bin/glibtoolize"
    keg_only "Xcode (up to and including 4.2) provides (a rather old) Libtool."
  end

  def options
    [["--universal", "Builds a universal binary"]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
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

  def test
    system "#{bin}/glibtoolize", "--version"
  end
end
