# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage "http://www.gnu.org/software/libtool/"
  url "http://ftpmirror.gnu.org/libtool/libtool-2.4.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.4.tar.xz"
  sha1 "a62d0f9a5c8ddf2de2a3210a5ab712fd3b4531e9"

  bottle do
    cellar :any
    sha1 "ab16612e09788dd35da992db1bdd05e28a457299" => :yosemite
    sha1 "c7ec9da0dc5103bf21c414299b1accb8c42e23a5" => :mavericks
    sha1 "f49fc49a492031b657a65ba168ac14a5c3705bdc" => :mountain_lion
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
