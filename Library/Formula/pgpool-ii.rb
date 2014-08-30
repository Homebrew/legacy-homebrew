require "formula"

class PgpoolIi < Formula
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.2.8.tar.gz"
  sha1 "77ae7f3472294e33837670a45579c72b12e2f50b"

  depends_on :postgresql

  # Fix strlcpy conflict. Patch adapted from upstream commit:
  # http://git.postgresql.org/gitweb/?p=pgpool2.git;a=commit;h=95a874ce94abc2859f53ecbd005d3332db423b48
  patch do
    url "https://gist.githubusercontent.com/jacknagel/10cef3c878cda8788b47/raw/e635efc28b63393aaea0aca896b898136849da07/pgpool.diff"
    sha1 "b653936ba47a0cea88a8bb45cc462d628498a370"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
