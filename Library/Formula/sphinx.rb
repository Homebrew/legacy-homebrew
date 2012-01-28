require 'formula'

class Libstemmer < Formula
  # upstream is constantly changing the tarball,
  # so doing checksum verification here would require
  # constant, rapid updates to this formula.
  head 'http://snowball.tartarus.org/dist/libstemmer_c.tgz'
  homepage 'http://snowball.tartarus.org/'
end

class Sphinx < Formula
  url 'http://sphinxsearch.com/files/sphinx-2.0.3-release.tar.gz'
  version '2.0.3'
  homepage 'http://www.sphinxsearch.com'
  md5 'a1293aecd5034aa797811610beb7ba89'
  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  fails_with_llvm "ld: rel32 out of range in _GetPrivateProfileString from /usr/lib/libodbc.a(SQLGetPrivateProfileString.o)",
    :build => 2334

  def install
    lstem = Pathname.pwd+'libstemmer_c'
    lstem.mkpath
    Libstemmer.new.brew { mv Dir['*'], lstem }

    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--localstatedir=#{var}"]

    # always build with libstemmer support
    args << "--with-libstemmer"

    # configure script won't auto-select PostgreSQL
    args << "--with-pgsql" if `/usr/bin/which pg_config`.size > 0
    args << "--without-mysql" unless `/usr/bin/which mysql`.size > 0

    system "./configure", *args
    system "make install"
  end

  def caveats
    <<-EOS.undent
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
