require "formula"

class Isync < Formula
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.1.0/isync-1.1.0.tar.gz"
  sha1 "d99bd9603e17f94ebe4af1691482a6676ea0fb42"

  head do
    url "git://git.code.sf.net/p/isync/isync"

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
