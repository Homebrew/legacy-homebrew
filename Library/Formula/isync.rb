require "formula"

class Isync < Formula
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.1.2/isync-1.1.2.tar.gz"
  sha1 "7f5778561fe5db5aceabab4a1a47eac845537c0b"

  head do
    url "git://git.code.sf.net/p/isync/isync"

    depends_on "openssl"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db"

  def install
    if build.head?
      touch "ChangeLog"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
