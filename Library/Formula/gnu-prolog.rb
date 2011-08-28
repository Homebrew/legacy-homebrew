require 'formula'

class GnuProlog < Formula
  url 'http://gprolog.univ-paris1.fr/gprolog-1.4.0.tar.gz'
  homepage 'http://www.gprolog.org/'
  md5 'cc944e5637a04a9184c8aa46c947fd16'

  skip_clean :all

  fails_with_llvm

  # Applies fix as seen here:
  # http://lists.gnu.org/archive/html/users-prolog/2011-07/msg00013.html
  def patches; DATA; end

  def install
    ENV.j1 # make won't run in parallel

    Dir.chdir 'src' do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install-strip"
    end
  end
end

__END__
diff -rupN a/src/configure b/src/configure
--- a/src/configure	2011-08-19 14:45:19.000000000 -0500
+++ b/src/configure	2011-08-19 14:47:00.000000000 -0500
@@ -3700,7 +3700,7 @@ else
     fi
     AS0=as
     case "$host" in
-        i*86*darwin10*)  ASFLAGS='-arch i686';;
+        i*86*darwin1*)  ASFLAGS='-arch i686';;
         x86_64*solaris*) AS0=gas; ASFLAGS='--64';;
         *)               if test "$with_gas" = yes; then AS0=gas; fi;;
     esac
@@ -4614,7 +4614,7 @@ else
 
     CFLAGS_MACHINE=
     case "$host" in
-        i*86*darwin10*)    CFLAGS_MACHINE='-march=i686 -m32';;
+        i*86*darwin1*)    CFLAGS_MACHINE='-march=i686 -m32';;
         mips*irix*)        CFLAGS_MACHINE='-march=4000';;
         *sparc*sunos4.1.3) CFLAGS_MACHINE='-msupersparc';;
         *sparc*solaris)    CFLAGS_MACHINE='-msupersparc';;
