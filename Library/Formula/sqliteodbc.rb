class Sqliteodbc < Formula
  desc "SQLite ODBC driver"
  homepage "http://www.ch-werner.de/sqliteodbc/"
  url "http://www.ch-werner.de/sqliteodbc/sqliteodbc-0.9992.tar.gz"
  sha256 "f5c6119cfb688fc3d2fbc500c6cfa796538b767c511be5ab90fb6805fcd289c3"

  depends_on "sqlite"
  depends_on "unixodbc"

  def install
    lib.mkdir
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install_symlink "#{lib}/libsqlite3odbc.dylib" => "libsqlite3odbc.so"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end
