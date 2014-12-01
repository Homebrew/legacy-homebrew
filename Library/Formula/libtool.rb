require "formula"

# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage "http://www.gnu.org/software/libtool/"
  url "http://ftpmirror.gnu.org/libtool/libtool-2.4.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.4.tar.xz"
  sha1 "a62d0f9a5c8ddf2de2a3210a5ab712fd3b4531e9"

  bottle do
    cellar :any
    revision 3
    sha1 "e172450c5686c7f7e13237c927cb49cce4c0ac0c" => :yosemite
    sha1 "bbf17c08138fb53a4512732a2dab4f5c8dbec364" => :mavericks
    sha1 "c749e65dee61cd23b7e757a1308761d8396689e4" => :mountain_lion
    sha1 "d709c921f42e1f299b5bf09314eb73ab0dfa716d" => :lion
  end

  keg_only :provided_until_xcode43

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
  end
end
