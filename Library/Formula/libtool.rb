require "formula"

# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage "http://www.gnu.org/software/libtool/"
  url "http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz"
  sha1 "22b71a8b5ce3ad86e1094e7285981cae10e6ff88"

  bottle do
    cellar :any
    revision 3
    sha1 "e172450c5686c7f7e13237c927cb49cce4c0ac0c" => :yosemite
    sha1 "bbf17c08138fb53a4512732a2dab4f5c8dbec364" => :mavericks
    sha1 "c749e65dee61cd23b7e757a1308761d8396689e4" => :mountain_lion
    sha1 "d709c921f42e1f299b5bf09314eb73ab0dfa716d" => :lion
  end

  keg_only :provided_until_xcode43

  option :universal

  # Allow -stdlib= to pass through to linker
  # http://git.savannah.gnu.org/gitweb/?p=libtool.git;a=commitdiff;h=8f975a1368594126e37d85511f1f96164e466d93
  # https://trac.macports.org/ticket/32982

  # Fix interpretation of MACOSX_DEPLOYMENT_TARGET on 10.10
  # http://article.gmane.org/gmane.comp.gnu.libtool.patches/11730
  # https://trac.macports.org/changeset/125325
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
  end
end

__END__
diff --git a/libltdl/config/ltmain.sh b/libltdl/config/ltmain.sh
index 63ae69d..9ae038c 100644
--- a/libltdl/config/ltmain.sh
+++ b/libltdl/config/ltmain.sh
@@ -5851,9 +5851,10 @@ func_mode_link ()
       # -tp=*                Portland pgcc target processor selection
       # --sysroot=*          for sysroot support
       # -O*, -flto*, -fwhopr*, -fuse-linker-plugin GCC link-time optimization
+      # -stdlib=*            select c++ std lib with clang
       -64|-mips[0-9]|-r[0-9][0-9]*|-xarch=*|-xtarget=*|+DA*|+DD*|-q*|-m*| \
       -t[45]*|-txscale*|-p|-pg|--coverage|-fprofile-*|-F*|@*|-tp=*|--sysroot=*| \
-      -O*|-flto*|-fwhopr*|-fuse-linker-plugin)
+      -O*|-flto*|-fwhopr*|-fuse-linker-plugin|-stdlib=*)
         func_quote_for_eval "$arg"
 	arg="$func_quote_for_eval_result"
         func_append compile_command " $arg"
diff --git a/configure b/configure
index a1ef3e3..782d28a 100755
--- a/configure
+++ b/configure
@@ -7765,7 +7765,7 @@ $as_echo "$lt_cv_ld_force_load" >&6; }
       case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
 	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-	10.[012]*)
+	10.[012][,.]*)
 	  _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
 	10.*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
diff --git a/libltdl/configure b/libltdl/configure
index f18f272..fef1137 100755
--- a/libltdl/configure
+++ b/libltdl/configure
@@ -6978,7 +6978,7 @@ $as_echo "$lt_cv_ld_force_load" >&6; }
       case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
 	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-	10.[012]*)
+	10.[012][,.]*)
 	  _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
 	10.*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
diff --git a/libltdl/m4/libtool.m4 b/libltdl/m4/libtool.m4
index 44e0ecf..4adcf73 100644
--- a/libltdl/m4/libtool.m4
+++ b/libltdl/m4/libtool.m4
@@ -1052,7 +1052,7 @@ _LT_EOF
       case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
 	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]]*)
+	10.[[012]][[,.]]*)
 	  _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
 	10.*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
