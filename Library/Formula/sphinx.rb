require 'formula'

class Sphinx < Formula
  homepage 'http://www.sphinxsearch.com'
  url 'http://sphinxsearch.com/files/sphinx-2.1.9-release.tar.gz'
  sha1 '2ddd945eb0a7de532a7aaed2e933ac05b978cff2'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  bottle do
    sha1 "ec438c2123c33a5cc41bf277ce22408424075261" => :mavericks
    sha1 "0b99dba174ea363d2d5c2da78e2a5f99b6e57400" => :mountain_lion
    sha1 "550021173abd3a528619c4da73d580dd54115003" => :lion
  end

  devel do
    url 'http://sphinxsearch.com/files/sphinx-2.2.3-beta.tar.gz'
    sha1 'ef78cebeae32a0582df504d74d6dd2ded81b73d9'
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
