class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-3.4.8.tar.bz2"
  sha256 "4f818fd09bff89625b4317cc7c05445f6e7bd9ea8d21e7eefeaaca07b8b0cd9f"

  bottle do
    sha256 "2a0f00945c39d66ccb6523e0418293ece655ea430dee6565fd3f6f2550054865" => :el_capitan
    sha256 "54c6fe77da6a45bfa61c54409aa27aa58fc1061739b103fb4bbd5646d314ae4f" => :yosemite
    sha256 "69c2b5840ec2a21a9654370f36f17d4ca42b5b5a7153e1917543874010dcdc63" => :mavericks
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  option "with-pgsql", "Enable the PostgreSQL backend"

  deprecated_option "pgsql" => "with-pgsql"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "sqlite"
  depends_on :postgresql if build.with? "pgsql"

  def install
    # https://github.com/Homebrew/homebrew/pull/33739
    ENV.deparallelize

    args = ["--prefix=#{prefix}",
            "--with-lua",
            "--with-sqlite3"]

    # Include the PostgreSQL backend if requested
    if build.with? "pgsql"
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
