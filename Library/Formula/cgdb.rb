require "formula"

class Cgdb < Formula
  homepage "http://cgdb.github.io/"
  url "http://cgdb.me/files/cgdb-0.6.7.tar.gz"
  sha1 "5e29e306502888dd660a9dd55418e5c190ac75bb"

  bottle do
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula['readline'].opt_prefix}"
    system "make install"
  end
end
