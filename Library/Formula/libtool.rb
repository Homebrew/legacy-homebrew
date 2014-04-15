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

  keg_only :provided_until_xcode43

  option :universal

  # Allow -stdlib= to pass through to linker
  # http://git.savannah.gnu.org/gitweb/?p=libtool.git;a=commitdiff;h=8f975a1368594126e37d85511f1f96164e466d93
  # https://trac.macports.org/ticket/32982
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
    system "#{bin}/glibtool", 'execute', '/usr/bin/true'
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
