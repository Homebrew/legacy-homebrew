class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-3.4.6.tar.bz2"
  sha256 "80a6a43cabd14db844bce84482ba56d03d46ebfbf96c88689fb3e2185ac286d8"

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  bottle do
    sha256 "aff809d5d325a08d0f15df934561f76357eb08568919143ccdc93d1a3cba545e" => :yosemite
    sha256 "92f2c51e1c07bc971871c7c495dc85b354efbf511f4bfd1c8b4a66536c8dba25" => :mavericks
    sha256 "723e2b4f9b9e92e657a6ef37f4fb3e9b6d7823d933517e92b569314300934322" => :mountain_lion
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
