class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.05.0100.tar.gz"
  sha256 "c53612db422826bfa3023ea8c75cb6c61f113a797a3323002ed645133491d1bd"

  bottle do
    cellar :any
    sha256 "4796f1ee0250a872f4c677a38ef19d5f707a8f869ab8131a17c81cf1a8dfd87b" => :el_capitan
    sha256 "dfe0350fc6da092fdef7c6247eda42001e9848a4468b485fcb8e391e1ff8a10f" => :yosemite
    sha256 "04ed0b32b3904384e211933d8ecf52759437792d0f4181296e0dd9144f702440" => :mavericks
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
