require "formula"

class Psqlodbc < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.03.0300.tar.gz"
  sha1 "0f41b4678b513aa70f14b03803af92a7abf1e179"

  bottle do
  end

  depends_on "openssl"
  depends_on "unixodbc"
  depends_on :postgresql

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = `#{Formula['unixodbc'].bin}/dltest #{lib}/psqlodbcw.so`
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
    assert_equal 0, $?.exitstatus
  end
end
