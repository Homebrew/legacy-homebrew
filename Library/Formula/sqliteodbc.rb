class Sqliteodbc < Formula
  desc "SQLite ODBC driver"
  homepage "http://www.ch-werner.de/sqliteodbc/"
  url "http://www.ch-werner.de/sqliteodbc/sqliteodbc-0.9992.tar.gz"
  sha256 "f5c6119cfb688fc3d2fbc500c6cfa796538b767c511be5ab90fb6805fcd289c3"

  bottle do
    cellar :any
    sha256 "08df3b27087e89c1d2b60932ea1156d33c9a8e50bd0f6709213ba00c10a4aa2b" => :el_capitan
    sha256 "973a3ec5518f5fbc9bcad2418bc5161dccf07209967b78954507a63abb87006d" => :yosemite
    sha256 "805ccaeb6e041dd95fa1ebc28b80e40a90bdd363bc1edd172f97bf7bc9b1b996" => :mavericks
  end

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
