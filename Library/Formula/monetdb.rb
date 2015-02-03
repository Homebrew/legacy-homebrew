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
  homepage "https://www.monetdb.org/"
  url "https://dev.monetdb.org/downloads/sources/Oct2014-SP2/MonetDB-11.19.9.zip"
  sha1 "dde2cad29d2f5bbdd2e2845ee0663969eb0aeb3f"

  bottle do
    sha1 "edb53b064fffddefe80a0447b00f521e4cac7a40" => :yosemite
    sha1 "d00ba596fa14345d4cf114bab08b42e481ab65ce" => :mavericks
    sha1 "b98435f66be2aa6dc04de3d373b2ce1e2d3d1f0d" => :mountain_lion
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
