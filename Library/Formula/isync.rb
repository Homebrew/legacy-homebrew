require "formula"

class Isync < Formula
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.1.1/isync-1.1.1.tar.gz"
  sha1 "be759ff7e7e141b91fc242284ddeb256d54a5567"

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
