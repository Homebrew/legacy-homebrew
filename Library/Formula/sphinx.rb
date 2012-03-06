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
  url 'http://sphinxsearch.com/files/sphinx-2.0.3-release.tar.gz'
  version '2.0.3'
  md5 'a1293aecd5034aa797811610beb7ba89'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  fails_with_llvm "ld: rel32 out of range in _GetPrivateProfileString from /usr/lib/libodbc.a(SQLGetPrivateProfileString.o)",
    :build => 2334

  # configure: error: Gcc version error. Minspec is 3.4
  # https://github.com/mxcl/homebrew/issues/10016
  def patches; DATA; end

  def install
    lstem = Pathname.pwd+'libstemmer_c'
    Libstemmer.new.brew { lstem.install Dir['*'] }

    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking",
            "--localstatedir=#{var}"]

    # always build with libstemmer support
    args << "--with-libstemmer"

    # configure script won't auto-select PostgreSQL
    args << "--with-pgsql" if which 'pg_config'
    args << "--without-mysql" unless which 'mysql'

    # sphinxexpr.cpp:1799:11: error: use of undeclared identifier 'ExprEval'
    # https://github.com/mxcl/homebrew/issues/10016
    # FIXME This should be replaced with fails_with_clang once available
    if ENV.compiler == :clang
      ENV.llvm
    end

    # search.cpp:1: error: bad value (native) for -march= switch
    # https://github.com/mxcl/homebrew/issues/10016
    ENV.remove_from_cflags /-march=native/
  
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
diff --git a/configure.ac b/configure.ac
index c86fcb9..cf4b17d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -60,7 +60,7 @@ AC_PROG_RANLIB
 AC_COMPILE_IFELSE([
 #ifdef __GNUC__
 #if __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ > 3)
-void main() {}
+int main() {}
 #else
 syntax error
 #endif
