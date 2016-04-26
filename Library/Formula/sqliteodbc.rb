class Sqliteodbc < Formula
  desc "SQLite ODBC driver"
  homepage "http://www.ch-werner.de/sqliteodbc/"
  url "http://www.ch-werner.de/sqliteodbc/sqliteodbc-0.9992.tar.gz"
  sha256 "f5c6119cfb688fc3d2fbc500c6cfa796538b767c511be5ab90fb6805fcd289c3"

  bottle do
    cellar :any
    revision 1
    sha256 "b48cbcd80134a93b694b2b01366970aa1114afad86acd921b484ddee3a64c9be" => :el_capitan
    sha256 "691272b6dd92741f4f8c1f7cb435c4fade6a03271fc0694d88378238d48a0f6e" => :yosemite
    sha256 "5ff36ea537f174e4db9f44da33db0d4a21b425f346d11eedd45582d85971ffb1" => :mavericks
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  def install
    lib.mkdir
    system "./configure", "--prefix=#{prefix}", "--with-odbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
    lib.install_symlink "#{lib}/libsqlite3odbc.dylib" => "libsqlite3odbc.so"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end
