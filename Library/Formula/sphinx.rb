class Sphinx < Formula
  desc "Sphinx is a full-text search engine"
  homepage "http://www.sphinxsearch.com"

  stable do
    url "http://sphinxsearch.com/files/sphinx-2.2.10-release.tar.gz"
    sha256 '054cb86e64bd48997d89386e1224d4405063d9857b2d7c33dc6cc1b9ef6df440'
  end

  devel do
    url "http://sphinxsearch.com/files/sphinx-2.3.1-beta.tar.gz"
    sha256 "0e5ebee66fe5b83dd8cbdebffd236dcd7cd33a7633c2e30b23330c65c61ee0e3"
  end

  head "http://sphinxsearch.googlecode.com/svn/trunk/"

  bottle do
    sha256 "becbeff5c3c56ff65a66ce321dbe19673be86bc2466b560f3be651c81a1166ed" => :el_capitan
    sha256 "7ac68d7f84767988fd1842b59999dba1226549f98847032ac179c763662b11d3" => :yosemite
    sha256 "0a6cab6b68544bce68a09912f5cd26b10cee817adf9a2ec6f3b011d46444323f" => :mavericks
  end

  option "with-mysql",      "Force compiling against MySQL"
  option "with-postgresql", "Force compiling against PostgreSQL"
  option "with-id64",       "Force compiling with 64-bit ID support"

  deprecated_option "mysql" => "with-mysql"
  deprecated_option "pgsql" => "with-postgresql"
  deprecated_option "id64"  => "with-id64"

  depends_on "re2" => :optional
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on "openssl" if build.with?("mysql")

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
      :revision => "9b58e92c965cd7e3208247ace3cc00d173397f3c"
  end

  fails_with :llvm do
    build 2334
    cause "ld: rel32 out of range in _GetPrivateProfileString from /usr/lib/libodbc.a(SQLGetPrivateProfileString.o)"
  end

  fails_with :clang do
    build 421
    cause "sphinxexpr.cpp:1802:11: error: use of undeclared identifier 'ExprEval'"
  end

  def install
    resource("stemmer").stage do
      system "make", "dist_libstemmer_c"
      system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
    end

    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --localstatedir=#{var}
              --with-libstemmer]

    args << "--enable-id64" if build.with? "id64"
    args << "--with-re2" if build.with? "re2"

    if build.with? "mysql"
      args << "--with-mysql"
    else
      args << "--without-mysql"
    end

    if build.with? "postgresql"
      args << "--with-pgsql"
    else
      args << "--without-pgsql"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    This is not sphinx - the Python Documentation Generator.
    To install sphinx-python use pip.

    Sphinx has been compiled with libstemmer support.

    Sphinx depends on either MySQL or PostreSQL as a datasource.

    You can install these with Homebrew with:
      brew install mysql
        For MySQL server.

      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install postgresql
        For PostgreSQL server.

    We don't install these for you when you install this formula, as
    we don't know which datasource you intend to use.
    EOS
  end
end
