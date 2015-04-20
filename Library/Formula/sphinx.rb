require 'formula'

class Sphinx < Formula
  homepage 'http://www.sphinxsearch.com'
  url 'http://sphinxsearch.com/files/sphinx-2.2.6-release.tar.gz'
  sha1 '9c458ed999a3e771d417a704e12c469e06423e4a'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  bottle do
    sha1 "96a941abefc28d95a3db766311ee222435fbdc4b" => :yosemite
    sha1 "087eda561408cc38e1bb1b86b32c441d169245f0" => :mavericks
    sha1 "780a6615a3ca764461810c88720dd71bafb3b37b" => :mountain_lion
  end

  option 'mysql', 'Force compiling against MySQL'
  option 'pgsql', 'Force compiling against PostgreSQL'
  option 'id64',  'Force compiling with 64-bit ID support'

  depends_on "re2" => :optional
  depends_on :mysql if build.include? 'mysql'
  depends_on :postgresql if build.include? 'pgsql'

  resource 'stemmer' do
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
    resource('stemmer').stage do
      system "make", "dist_libstemmer_c"
      system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
    end

    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --localstatedir=#{var}
              --with-libstemmer]

    args << "--enable-id64" if build.include? 'id64'
    args << "--with-re2" if build.with? 're2'

    %w{mysql pgsql}.each do |db|
      if build.include? db
        args << "--with-#{db}"
      else
        args << "--without-#{db}"
      end
    end

    system "./configure", *args
    system "make install"
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
