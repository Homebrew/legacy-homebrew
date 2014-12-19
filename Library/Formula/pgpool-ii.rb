require "formula"

class PgpoolIi < Formula
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.0.tar.gz"
  sha1 "5502268055b6ba48013c1b7c9ac5a8ce3a0d30ed"

  bottle do
    sha1 "b05f96a3f5d0ff02afea65aa50fa33ca1f75defb" => :yosemite
    sha1 "621632adc180b378e427e21587c0c005e8b125db" => :mavericks
    sha1 "26d1434b15ce5f716012bc204b8b01e05b0574c7" => :mountain_lion
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
