require "formula"

class RRequirement < Requirement
  fatal true

  satisfy { which('r') }

  def message; <<-EOS.undent
    R not found. The R integration module requires R.
    Do one of the following:
    - install R
    -- run brew install homebrew/science/r or brew install Caskroom/cask/r
    - remove the --with-r option
    EOS
  end
end

class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://dev.monetdb.org/downloads/sources/Oct2014-SP4/MonetDB-11.19.15.zip"
  sha256 "bb32560bd66496581416abcf8f84dfe13616f405092f9ee570e1411534af635c"

  bottle do
    sha256 "41605243b56eb90d354d970de4815f09e79f0920494e1a698457c69877018ac1" => :yosemite
    sha256 "7b1b973ac5e55cfd3be69279ae2cb56bde3a45ed09a7b8997df6aa0a56c78fd7" => :mavericks
    sha256 "477c96cd73680b694972e4cf9b32ade1d3d4f1fcb2a1c254938f21da5a46667d" => :mountain_lion
  end

  head do
    url "http://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-java", 'Build the JDBC dirver'
  option "with-r", 'Build the R integration module'

  depends_on RRequirement => :optional

  depends_on "pkg-config" => :build
  depends_on :ant => :build
  depends_on "libatomic_ops" => [:build, :recommended]
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit.
  depends_on "openssl"

  depends_on "unixodbc" => :optional # Build the ODBC driver
  depends_on "geos" => :optional # Build the GEOM module
  depends_on "gsl" => :optional
  depends_on "cfitsio" => :optional
  depends_on "homebrew/php/libsphinxclient" => :optional

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-debug=no",
            "--enable-assert=no",
            "--enable-optimize=yes",
            "--enable-testing=no",
            "--with-readline=#{Formula["readline"].opt_prefix}", # Use the correct readline
            "--without-rubygem"] # Installing the RubyGems requires root permissions

    args << "--with-java=no" if build.without? "java"
    args << "--disable-rintegration" if build.without? "r"

    system "./configure", *args
    system "make install"
  end
end
