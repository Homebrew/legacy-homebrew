require "formula"

class Lft < Formula
  homepage "http://pwhois.org/lft/"
  url "http://pwhois.org/dl/index.who?file=lft-3.73.tar.gz"
  sha1 "c5a37bef74d7466d5202ee8136acc3213711252e"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
