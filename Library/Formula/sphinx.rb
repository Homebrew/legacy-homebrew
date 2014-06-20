require 'formula'

class Sphinx < Formula
  homepage 'http://www.sphinxsearch.com'
  url 'http://sphinxsearch.com/files/sphinx-2.1.8-release.tar.gz'
  sha1 'c69e24ed1fad907b893dc61b0a52db30b6c85ad2'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  devel do
    url 'http://sphinxsearch.com/files/sphinx-2.2.2-beta.tar.gz'
    sha1 '6a63111c5f2fcd93915d114845f2375b031ff9da'
  end

  option 'mysql', 'Force compiling against MySQL'
  option 'pgsql', 'Force compiling against PostgreSQL'
  option 'id64',  'Force compiling with 64-bit ID support'

  depends_on :mysql if build.include? 'mysql'
  depends_on :postgresql if build.include? 'pgsql'

  # http://snowball.tartarus.org/
  resource 'stemmer' do
    url 'http://snowball.tartarus.org/dist/libstemmer_c.tgz'
    sha1 'bbe1ba5bbebb146575a575b8ca3342aa3b91bf93'
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
