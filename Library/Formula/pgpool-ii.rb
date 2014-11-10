require "formula"

class PgpoolIi < Formula
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.0.tar.gz"
  sha1 "5502268055b6ba48013c1b7c9ac5a8ce3a0d30ed"

  depends_on :postgresql

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
