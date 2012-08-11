require 'formula'

class Libstemmer < Formula
  # upstream is constantly changing the tarball,
  # so doing checksum verification here would require
  # constant, rapid updates to this formula.
  head 'http://snowball.tartarus.org/dist/libstemmer_c.tgz'
  homepage 'http://snowball.tartarus.org/'
end

class Sphinx < Formula
  homepage 'http://www.sphinxsearch.com'
  url 'http://sphinxsearch.com/files/sphinx-2.0.4-release.tar.gz'
  md5 '7da4df3df3decb24d8c6fb8f47de1d3d'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  fails_with :llvm do
    build 2334
    cause "ld: rel32 out of range in _GetPrivateProfileString from /usr/lib/libodbc.a(SQLGetPrivateProfileString.o)"
  end

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      sphinxexpr.cpp:1802:11: error: use of undeclared identifier 'ExprEval'
    EOS
  end

  def options
    [
      ['--mysql', 'Force compiling against MySQL.'],
      ['--pgsql', 'Force compiling against PostgreSQL.'],
      ['--id64',  'Force compiling with 64-bit ID support'],
    ]
  end

  def install
    Libstemmer.new.brew { (buildpath/'libstemmer_c').install Dir['*'] }

    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --localstatedir=#{var}]

    # always build with libstemmer support
    args << "--with-libstemmer"

    # configure script won't auto-select PostgreSQL
    args << "--with-pgsql" if ARGV.include?('--pgsql') or which 'pg_config'
    args << "--enable-id64" if ARGV.include?('--id64')
    args << "--without-mysql" unless ARGV.include?('--mysql') or which 'mysql_config'

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

__END__
diff --git a/configure b/configure
index aebac75..82d6d05 100755
--- a/configure
+++ b/configure
@@ -4361,7 +4361,7 @@ cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 
 #ifdef __GNUC__
 #if __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ > 3)
-void main() {}
+int main() {}
 #else
 syntax error
 #endif
