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
  url "https://www.monetdb.org/downloads/sources/Jul2015-SP1/MonetDB-11.21.11.zip"
  sha256 "9ca39c4943f1667b62337d6816b100af5f02551f999c22dfd5d71a7c2773eafb"

  bottle do
    sha256 "694824bd2c7e7a199bbff0ec2b4d8afd827339f9bcd22c17d9508dbd8e3e4c34" => :el_capitan
    sha256 "f1cb35fa9fdd74aeeaf64fca8404ae8979496417b8ee3028b1e33e3762f0c3e0" => :yosemite
    sha256 "735b0a0099edb416895cc5c7ba2bc265628db23a7ccd3bf44342f90a6f3cf97b" => :mavericks
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
