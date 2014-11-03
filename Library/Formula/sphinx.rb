require 'formula'

class Sphinx < Formula
  homepage 'http://www.sphinxsearch.com'
  url 'http://sphinxsearch.com/files/sphinx-2.2.5-release.tar.gz'
  sha1 '27e1a37fdeff12b866b33d3bb5602894af10bb5e'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  bottle do
    sha1 "39090ca7d66167464aed584caf5ec21dcd234fc3" => :mavericks
    sha1 "95cc0d4a21c091a91e50c3ce4000b2c7196c71bc" => :mountain_lion
    sha1 "57564d0b2d3e788f9b5e78fad94cac39d9d991e0" => :lion
  end

  option 'mysql', 'Force compiling against MySQL'
  option 'pgsql', 'Force compiling against PostgreSQL'
  option 'id64',  'Force compiling with 64-bit ID support'

  depends_on "re2" => :optional
  depends_on :mysql if build.include? 'mysql'
  depends_on :postgresql if build.include? 'pgsql'

  # http://snowball.tartarus.org/
  resource 'stemmer' do
    url 'http://snowball.tartarus.org/dist/libstemmer_c.tgz'
    sha1 '9b0f120a68a3c688b2f5a8d0f681620465c29d38'
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
    (buildpath/'libstemmer_c').install resource('stemmer')

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
