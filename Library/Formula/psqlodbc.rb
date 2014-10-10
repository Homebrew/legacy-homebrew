require "formula"

class Psqlodbc < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.03.0210.tar.gz"
  sha1 "e1eb147ef0452e1f7b0f9e102dacb5654a580dba"
  revision 2

  bottle do
    cellar :any
    sha1 "12578b9af31ef6acdcbd3afd4f30d4f6ff3d66c3" => :mavericks
    sha1 "34051761751ad9e60217f7c13d5988146f734f06" => :mountain_lion
    sha1 "caef85b8bc14586dfaf482943fbd20b53a9e70ec" => :lion
  end

  depends_on "openssl"
  depends_on "unixodbc"
  depends_on :postgresql

  def install
    args = ["--prefix=#{prefix}",
            "--with-unixodbc=#{Formula['unixodbc'].prefix}"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = `#{Formula['unixodbc'].bin}/dltest #{lib}/psqlodbcw.so`
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
    assert_equal 0, $?.exitstatus
  end
end
