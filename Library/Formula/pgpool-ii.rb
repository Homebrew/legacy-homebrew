require "formula"

class PgpoolIi < Formula
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.2.9.tar.gz"
  sha1 "ce5bcaaa46ec3ed6da3aff630329e8ad15cc4ba8"

  depends_on :postgresql

  # Fix strlcpy conflict. Patch adapted from upstream commit:
  # http://git.postgresql.org/gitweb/?p=pgpool2.git;a=commit;h=95a874ce94abc2859f53ecbd005d3332db423b48
  patch do
    url "https://gist.githubusercontent.com/jacknagel/10cef3c878cda8788b47/raw/f38694935674644baea95316c52b0027a2a3c17f/pgpool.diff"
    sha1 "510bdfcee4b966dff26f338f33283c20522423e2"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
