# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage "https://www.gnu.org/software/libtool/"
  url "http://ftpmirror.gnu.org/libtool/libtool-2.4.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.5.tar.xz"
  sha1 "b75650190234ed898757ec8ca033ffabbee89e7c"

  bottle do
    cellar :any
    sha1 "a0a8f63f52eb81731873f05336c194b1ef31fc3b" => :yosemite
    sha1 "21dbadc74ca8bd189e981813dc7acc586640a934" => :mavericks
    sha1 "5af44fab5def8f1ddcd8e1cf97cc9aba52652af0" => :mountain_lion
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
