require "formula"

class Pdns < Formula
  homepage "http://www.powerdns.com"
  url "http://downloads.powerdns.com/releases/pdns-3.4.1.tar.bz2"
  sha1 "e4d807b4dc27ef130a49e0efaf82a74cb66f5b11"

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  bottle do
    sha1 "e39b0c25f869f94fa5b8d86af210baa980fce2ce" => :yosemite
    sha1 "62bcb4ddeb59d8ef5b8dad7cfa9fdbebf698a9f0" => :mavericks
    sha1 "e297580e0699c5d3c4aba341a7ad95c4945993bb" => :mountain_lion
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
