require "formula"

class Gnupg < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.18.tar.bz2"
  mirror "http://mirror.switch.ch/ftp/mirror/gnupg/gnupg/gnupg-1.4.18.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/gnupg/gnupg-1.4.18.tar.bz2"
  sha1 "41462d1a97f91abc16a0031b5deadc3095ce88ae"
  revision 1

  bottle do
    sha1 "a7dd53e1f78cea0de1425135bc95413befe91f14" => :yosemite
    sha1 "e8779b165cf4c02abc3233ece77f1527f1ab582f" => :mavericks
    sha1 "5359b2e2935e174304b23e9160758e4598fed3ce" => :mountain_lion
  end

  option "8192", "Build with support for private keys of up to 8192 bits"

  depends_on "curl" if MacOS.version <= :mavericks

  def install
    inreplace "g10/keygen.c", "max=4096", "max=8192" if build.include? "8192"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make"
    system "make check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/"gnupg"].each(&:mkpath)
    system "make install"
  end
end
