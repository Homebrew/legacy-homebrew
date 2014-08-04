require "formula"

class Gnupg < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.18.tar.bz2"
  mirror "http://mirror.switch.ch/ftp/mirror/gnupg/gnupg/gnupg-1.4.18.tar.bz2"
  sha1 "41462d1a97f91abc16a0031b5deadc3095ce88ae"

  bottle do
    sha1 "febc9b5402dbfe8d0dce5a22307e7b694ae0dbfe" => :mavericks
    sha1 "76952357fe139cefaf22331ee39ef9723a3d11c9" => :mountain_lion
    sha1 "5972ed0cd1a34fe60313630446ae6cf8cbd95417" => :lion
  end

  option "8192", "Build with support for private keys of up to 8192 bits"

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
