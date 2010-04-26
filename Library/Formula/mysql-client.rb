require 'formula'

class MysqlClient <Formula
  homepage 'http://dev.mysql.com/doc/refman/5.1/en/'
  url 'http://mysql.llarian.net/Downloads/MySQL-5.1/mysql-5.1.46.tar.gz'

  depends_on 'readline'

  def patches
    DATA
  end

  def install
    ENV.gcc_4_2 # http://github.com/mxcl/homebrew/issues/#issue/144

    # See: http://dev.mysql.com/doc/refman/5.1/en/configure-options.html
    # These flags may not apply to gcc 4+
    ENV['CXXFLAGS'] = ENV['CXXFLAGS'].gsub "-fomit-frame-pointer", ""
    ENV['CXXFLAGS'] += " -fno-omit-frame-pointer -felide-constructors"
    configure_args = [
      "--with-docs",
      "--with-debug",
      "--prefix=#{prefix}",
      "--with-unix-socket-path=/tmp/mysql.sock",
      "--localstatedir=#{var}/mysql",
      "--sysconfdir=#{etc}",
      "--with-plugins=innobase,myisam",
      "--with-mysqld-user=mysql",
      "--with-extra-charsets=complex",
      "--with-ssl",
      "--enable-assembler",
      "--enable-thread-safe-client",
      "--enable-local-infile",
      "--without-server",
      "--enable-shared"]

    system "./configure", *configure_args
    system "make install"

  end

end


__END__
--- old/scripts/mysqld_safe.sh	2009-09-02 04:10:39.000000000 -0400
+++ new/scripts/mysqld_safe.sh	2009-09-02 04:52:55.000000000 -0400
@@ -383,7 +383,7 @@
 fi
 
 USER_OPTION=""
-if test -w / -o "$USER" = "root"
+if test -w /sbin -o "$USER" = "root"
 then
   if test "$user" != "root" -o $SET_USER = 1
   then
diff --git a/scripts/mysql_config.sh b/scripts/mysql_config.sh
index efc8254..8964b70 100644
--- a/scripts/mysql_config.sh
+++ b/scripts/mysql_config.sh
@@ -132,7 +132,8 @@ for remove in DDBUG_OFF DSAFEMALLOC USAFEMALLOC DSAFE_MUTEX \
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]'
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
