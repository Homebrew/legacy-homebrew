require 'formula'

class Sphinx <Formula
  url 'http://sphinxsearch.com/downloads/sphinx-0.9.9.tar.gz'
  homepage 'http://www.sphinxsearch.com'
  md5 '7b9b618cb9b378f949bb1b91ddcc4f54'
  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  def install
    fails_with_llvm "fails with: ld: rel32 out of range in _GetPrivateProfileString from /usr/lib/libodbc.a(SQLGetPrivateProfileString.o)"

    config_args = ["--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"]
    # configure script won't auto-select PostgreSQL
    config_args << "--with-pgsql" if `/usr/bin/which pg_config`.size > 0
    config_args << "--without-mysql" if `/usr/bin/which mysql`.size <= 0

    system "./configure", *config_args
    system "make install"
  end

  def caveats
    <<-EOS.undent
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
