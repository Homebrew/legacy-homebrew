require "formula"

class Pdns < Formula
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-3.4.3.tar.bz2"
  sha256 "5cd9a087757066427cd0c348f546cb84b4be4bd5e06c7ce969ec2bc21dbb8ce6"

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  bottle do
    sha256 "3a7f094cb9b8b1a418862f8b81b178e9f61d6ba93f223c658100aa1b99f87995" => :yosemite
    sha256 "deb9493b529254d3124233220f6185c31e7e14d94568ad5d0596541d415958be" => :mavericks
    sha256 "c11417e1e0751444d15e8f4b11eb8b4218a707cdfdfdd3cab8adc5e38a01e6da" => :mountain_lion
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
