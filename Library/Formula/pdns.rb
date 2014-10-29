require "formula"

class Pdns < Formula
  homepage "http://www.powerdns.com"
  url "http://downloads.powerdns.com/releases/pdns-3.4.0.tar.bz2"
  sha1 "b1c5bf10e03c04f707b752b5159db06179c172d9"

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  bottle do
    sha1 "be0e2cae3ab4502568b050cd1c7cadcb8a7205d9" => :yosemite
    sha1 "299df17ba2070546dd9e1baeb9a82188f4ae4d8c" => :mavericks
    sha1 "ff04dae2726cfe50b2535a96c88aa325d04d7aa1" => :mountain_lion
  end

  option "pgsql", "Enable the PostgreSQL backend"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "sqlite"
  depends_on :postgresql if build.include? "pgsql"

  def install
    args = ["--prefix=#{prefix}",
            "--with-lua",
            "--with-sqlite3"]

    # Specifying the sqlite prefix is no longer recognised in the HEAD.
    args << "--with-sqlite=#{Formula["sqlite"].opt_prefix}" if build.stable?

    # Include the PostgreSQL backend if requested
    if build.include? "pgsql"
      args << "--with-modules=gsqlite3 gpgsql"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Compilation fails at polarssl if we skip straight to make install
    system "make"
    system "make", "install"
  end
end
