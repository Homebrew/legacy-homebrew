require "formula"

class Psqlodbc < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.03.0210.tar.gz"
  sha1 "e1eb147ef0452e1f7b0f9e102dacb5654a580dba"
  bottle do
    cellar :any
    revision 1
    sha1 "14da3adcbbb44feeb9269b817ef83ae96992dc0c" => :mavericks
    sha1 "59cae2eafaecc1d2f844d43c56591586b31cbfc5" => :mountain_lion
    sha1 "d9e55bbc56370d92b49de3c18f34948d0ad7bbf7" => :lion
  end

  revision 1

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
