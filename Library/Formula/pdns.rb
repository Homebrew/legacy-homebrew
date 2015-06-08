require "formula"

class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-3.4.4.tar.bz2"
  sha256 "ec49f5a0b55b69ba057bf9ce28ab81e5258fc60c8d4954d9100fe3bb3efd09c8"

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  bottle do
    sha256 "a29c373c4303b29ca09e4bb764503496bdd9eb9c7ec5c43efbd40cdda2fbf6b3" => :yosemite
    sha256 "417271a4bfdd115b7fac2d7b4709b608eedabef07c4c3a757e56d0357987721b" => :mavericks
    sha256 "32dbdaab6b90d2caa6da03aca0b7b71b7e7227ea902a4ba4c82917cef30454c0" => :mountain_lion
  end

  option "pgsql", "Enable the PostgreSQL backend"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "sqlite"
  depends_on :postgresql if build.include? "pgsql"

  def install
    # https://github.com/Homebrew/homebrew/pull/33739
    ENV.deparallelize

    args = ["--prefix=#{prefix}",
            "--with-lua",
            "--with-sqlite3"]

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
