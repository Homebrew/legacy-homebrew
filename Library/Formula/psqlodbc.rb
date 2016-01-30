class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.05.0100.tar.gz"
  sha256 "c53612db422826bfa3023ea8c75cb6c61f113a797a3323002ed645133491d1bd"

  bottle do
    cellar :any
    sha256 "cb3f7f8239315732ba9e380b149edc0d14e74a3e7b8c87563dad5f23a463e8ec" => :yosemite
    sha256 "4a1d5a33b5910e87caebf9414bfe1f699b1b15b8da6401ccb683babe6b652206" => :mavericks
    sha256 "03cfeabccdb83370de666f11525b12f4775c7c79977740c1725334f90f4e1b91" => :mountain_lion
  end

  head do
    url "http://git.postgresql.org/git/psqlodbc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "unixodbc"
  depends_on :postgresql

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
