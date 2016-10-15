class Tdb < Formula
  homepage "https://tdb.samba.org"
  url "https://www.samba.org/ftp/tdb/tdb-1.3.4.tar.gz"
  sha1 "585d188267e4ba698c86b86703cc8cd97f1a71ac"

  depends_on "docbook-xsl" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
