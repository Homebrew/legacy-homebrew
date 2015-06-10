class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-3.4.5.tar.bz2"
  sha256 "f3e1441532b0af05a6b5efe5346f02d0c55f252fbed62d5b4f2e4a80997c507d"

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  bottle do
    sha256 "bd0f7efe36c7dd209cb25f176e53c83267257c85d905e2c0f2c0d5ba8b143036" => :yosemite
    sha256 "2208e81d5fa958a76369a9a272bdcf68f036b2215373802f7eb2b4b63e494c69" => :mavericks
    sha256 "17337c21a75dc9fd791cbfd9d3d7653d366c400d34aa261d836a93fd53fdb73f" => :mountain_lion
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
