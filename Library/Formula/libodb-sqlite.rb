require "formula"

class LibodbSqlite < Formula
  homepage "http://www.codesynthesis.com/products.odb"
  url "http://www.codesynthesis.com/download/odb/2.3/libodb-sqlite-2.3.0.tar.bz2"
  sha1 "512a124e0b78ae36deee25d595e3e169bd24d216"

  depends_on "libodb" =>:build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
