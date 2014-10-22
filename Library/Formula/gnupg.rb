require "formula"

class Gnupg < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.18.tar.bz2"
  mirror "http://mirror.switch.ch/ftp/mirror/gnupg/gnupg/gnupg-1.4.18.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/gnupg/gnupg-1.4.18.tar.bz2"
  sha1 "41462d1a97f91abc16a0031b5deadc3095ce88ae"
  revision 1

  bottle do
    revision 1
    sha1 "8bf10974d6ae46bdcf138a8020e2fc97e1f8f01f" => :yosemite
    sha1 "6581c11d74688e9824b08b62ba50965152551c4f" => :mavericks
    sha1 "4e11db0384bbdd7651dc1957d28be02476c5aab6" => :mountain_lion
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
