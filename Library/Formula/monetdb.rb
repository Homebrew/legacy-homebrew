class RRequirement < Requirement
  fatal true

  satisfy { which("r") }

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
  url "https://www.monetdb.org/downloads/sources/Jul2015-SP2/MonetDB-11.21.13.zip"
  sha256 "1638d74fbfbccc61e7e72e470114e24f6b31f3449e28b14febeffa8bd380ef69"

  bottle do
    sha256 "131544e89f4bab795fdfd3b0a5e6ea15f96e77978a4994bb91ebab84b232cdc3" => :el_capitan
    sha256 "f76d2f0f1af2fa543cf6d71f54469a61ef7caa3ae111b3fff60d16ccfb759d92" => :yosemite
    sha256 "9b4a4c12b180443488d7bd780b4c18490d87f34e87a3374fe29f2b1055927e09" => :mavericks
  end

  head do
    url "http://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-java", "Build the JDBC driver"
  option "with-ruby", "Build the Ruby driver"
  option "with-r", "Build the R integration module"

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
            "--with-readline=#{Formula["readline"].opt_prefix}"]

    args << "--with-java=no" if build.without? "java"
    args << "--with-rubygem=no" if build.without? "ruby"
    args << "--disable-rintegration" if build.without? "r"

    system "./configure", *args
    system "make", "install"
  end
end
