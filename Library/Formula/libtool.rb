require 'formula'

# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage 'http://www.gnu.org/software/libtool/'
  url 'http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz'
  sha1 '22b71a8b5ce3ad86e1094e7285981cae10e6ff88'

  bottle do
    revision 2
    sha1 '860a75329b31aa8729d71438d6a696fd453a85e4' => :mavericks
    sha1 'd97af1451dd547b5857bddfa8e5f241fd78d7c9d' => :mountain_lion
    sha1 '6873a7b72e86f369f43125c0e29ae5cdbc2d67c1' => :lion
  end

  if MacOS::Xcode.provides_autotools? or File.file? "/usr/bin/glibtoolize"
    keg_only "Xcode 4.2 and below provide glibtool."
  end

  option :universal

  # Allow -stdlib= to pass through to linker
  # http://git.savannah.gnu.org/gitweb/?p=libtool.git;a=commitdiff;h=8f975a1368594126e37d85511f1f96164e466d93
  # https://trac.macports.org/ticket/32982
  def patches; DATA; end

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
    system "#{bin}/glibtool", 'execute', '/usr/bin/true'
  end
end

__END__
diff --git a/libltdl/config/ltmain.sh b/libltdl/config/ltmain.sh
index 63ae69d..45bee2c 100644
--- a/libltdl/config/ltmain.sh
+++ b/libltdl/config/ltmain.sh
@@ -5546,13 +5546,17 @@ func_mode_link ()
 	continue
 	;;
 
-      -L*)
-	func_stripname "-L" '' "$arg"
+      -L*|-F*)
+      case $arg in
+      -F*) LF_prefix="-F" ;;
+      *) LF_prefix="-L" ;;
+      esac
+ func_stripname "$LF_prefix" '' "$arg"
 	if test -z "$func_stripname_result"; then
 	  if test "$#" -gt 0; then
-	    func_fatal_error "require no space between \`-L' and \`$1'"
+     func_fatal_error "require no space between \`$LF_prefix' and \`$1'"
 	  else
-	    func_fatal_error "need path for \`-L' option"
+     func_fatal_error "need path for \`$LF_prefix' option"
 	  fi
 	fi
 	func_resolve_sysroot "$func_stripname_result"
@@ -5568,14 +5572,14 @@ func_mode_link ()
 	  ;;
 	esac
 	case "$deplibs " in
-	*" -L$dir "* | *" $arg "*)
+ *" $LF_prefix$dir "* | *" $arg "*)
 	  # Will only happen for absolute or sysroot arguments
 	  ;;
 	*)
 	  # Preserve sysroot, but never include relative directories
 	  case $dir in
 	    [\\/]* | [A-Za-z]:[\\/]* | =*) func_append deplibs " $arg" ;;
-	    *) func_append deplibs " -L$dir" ;;
+     *) func_append deplibs " $LF_prefix$dir" ;;
 	  esac
 	  func_append lib_search_path " $dir"
 	  ;;
@@ -5851,9 +5855,10 @@ func_mode_link ()
       # -tp=*                Portland pgcc target processor selection
       # --sysroot=*          for sysroot support
       # -O*, -flto*, -fwhopr*, -fuse-linker-plugin GCC link-time optimization
+      # -stdlib=*            select c++ std lib with clang      
       -64|-mips[0-9]|-r[0-9][0-9]*|-xarch=*|-xtarget=*|+DA*|+DD*|-q*|-m*| \
-      -t[45]*|-txscale*|-p|-pg|--coverage|-fprofile-*|-F*|@*|-tp=*|--sysroot=*| \
-      -O*|-flto*|-fwhopr*|-fuse-linker-plugin)
+      -t[45]*|-txscale*|-p|-pg|--coverage|-fprofile-*|@*|-tp=*|--sysroot=*| \
+      -O*|-flto*|-fwhopr*|-fuse-linker-plugin|-stdlib=*)
         func_quote_for_eval "$arg"
 	arg="$func_quote_for_eval_result"
         func_append compile_command " $arg"
@@ -6261,13 +6266,17 @@ func_mode_link ()
 	  fi
 	  continue
 	  ;;
-	-L*)
+ -L*|-F*)
+    case $deplib in
+    -F*) LF_prefix="-F" ;;
+    *) LF_prefix="-L" ;;
+    esac
 	  case $linkmode in
 	  lib)
 	    deplibs="$deplib $deplibs"
 	    test "$pass" = conv && continue
 	    newdependency_libs="$deplib $newdependency_libs"
-	    func_stripname '-L' '' "$deplib"
+     func_stripname "$LF_prefix" '' "$deplib"
 	    func_resolve_sysroot "$func_stripname_result"
 	    func_append newlib_search_path " $func_resolve_sysroot_result"
 	    ;;
@@ -6282,16 +6291,16 @@ func_mode_link ()
 	      compile_deplibs="$deplib $compile_deplibs"
 	      finalize_deplibs="$deplib $finalize_deplibs"
 	    fi
-	    func_stripname '-L' '' "$deplib"
+     func_stripname "$LF_prefix" '' "$deplib"
 	    func_resolve_sysroot "$func_stripname_result"
 	    func_append newlib_search_path " $func_resolve_sysroot_result"
 	    ;;
 	  *)
-	    func_warning "\`-L' is ignored for archives/objects"
+     func_warning "\`$LF_prefix' is ignored for archives/objects"
 	    ;;
 	  esac # linkmode
 	  continue
-	  ;; # -L
+   ;; # -L/-F
 	-R*)
 	  if test "$pass" = link; then
 	    func_stripname '-R' '' "$deplib"
