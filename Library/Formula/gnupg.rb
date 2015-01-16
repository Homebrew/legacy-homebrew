require "formula"

class Gnupg < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.18.tar.bz2"
  mirror "http://mirror.switch.ch/ftp/mirror/gnupg/gnupg/gnupg-1.4.18.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/gnupg/gnupg-1.4.18.tar.bz2"
  sha1 "41462d1a97f91abc16a0031b5deadc3095ce88ae"
  revision 1

  bottle do
    revision 2
    sha1 "e1ea1c3bd682a15370f596a31297eb19ff87998e" => :yosemite
    sha1 "71e3618e2f4ea550e194938f6742772fb7d376d9" => :mavericks
    sha1 "f933064e91d20ebdb48f6f2180fdf7b99e814b8c" => :mountain_lion
  end

  depends_on "curl" if MacOS.version <= :mavericks

  def install
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
