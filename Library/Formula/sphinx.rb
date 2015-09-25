class Sphinx < Formula
  desc "Sphinx is a full-text search engine"
  homepage "http://www.sphinxsearch.com"
  revision 1

  stable do
    url "http://sphinxsearch.com/files/sphinx-2.2.9-release.tar.gz"
    sha256 "79bcb9fca069ba630fd71fb40fba05bb16e19b475906fb6ae026334d50a6bf3a"
  end

  devel do
    url "http://sphinxsearch.com/files/sphinx-2.3.1-beta.tar.gz"
    sha256 "0e5ebee66fe5b83dd8cbdebffd236dcd7cd33a7633c2e30b23330c65c61ee0e3"
  end

  head "http://sphinxsearch.googlecode.com/svn/trunk/"

  bottle do
    sha256 "cea5528dedeb1e66509271e8e1dab5d613ac6b203e16605830f68d57fa83f5b6" => :el_capitan
    sha256 "c9cdc77ed228f264c3f93293215cdb621129f52b90c49e157ac69ecf85027b16" => :yosemite
    sha256 "b46915db19659083d4a6428a704dac03a4c4d4a2b0d88ad32902c5c739715714" => :mavericks
    sha256 "419d876d846d9ad280be6f8ffdde5962cc6cb5accb32688e8af44f8c4e50989d" => :mountain_lion
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
    To install sphinx-python: use pip or easy_install,

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
