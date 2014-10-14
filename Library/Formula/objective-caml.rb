require 'formula'

class ObjectiveCaml < Formula
  homepage 'http://ocaml.org'
  url 'http://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-4.01.0.tar.gz'
  sha1 '31ae98051d42e038f4fbc5fd338c4fa5c36744e0'

  head 'http://caml.inria.fr/svn/ocaml/trunk', :using => :svn

  revision 1

  depends_on :x11 => :recommended

  bottle do
    revision 3
    sha1 "33e3a1cb87802572e531c801958ca6cdeee4cfbc" => :mavericks
    sha1 "c418ec76d9f5eba9e1c2151a6e1c89e91da8d212" => :mountain_lion
    sha1 "7da29c24adfd64772e2c3cca8b8502a1d6ce9fe0" => :lion
  end

  # recent versions of clang fail with a hard error if -fno-defer-pop
  # is specified, and older versions warn. This patch fixes the OCaml
  # configure script to not pass this option on recent MacOS versions.
  # See http://caml.inria.fr/mantis/view.php?id=6346 for upstream bug.
  patch :DATA

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX,
                          "--mandir", man,
                          "-cc", ENV.cc,
                          "-with-debug-runtime",
                          "-aspp", "#{ENV.cc} -c"
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def post_install
    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    (lib/"ocaml").install_symlink HOMEBREW_PREFIX/"lib/ocaml/site-lib"
  end
end
__END__
diff --git a/configure b/configure
index d45e88f..25d872b 100755
--- a/configure
+++ b/configure
@@ -322,7 +322,14 @@ case "$bytecc,$target" in
     bytecccompopts="-fno-defer-pop $gcc_warnings -DSHRINKED_GNUC"
     mathlib="";;
   *,*-*-darwin*)
-    bytecccompopts="-fno-defer-pop $gcc_warnings"
+    # On recent version of OSX, gcc is a symlink to clang
+    if $bytecc --version | grep -q clang; then
+        # -fno-defer-pop is not supported by clang, and make recent
+        # versions of clang to fail
+        bytecccompopts="$gcc_warnings"
+    else
+        bytecccompopts="-fno-defer-pop $gcc_warnings"
+    fi
     mathlib=""
     mkexe="$mkexe -Wl,-no_compact_unwind"
     # Tell gcc that we can use 32-bit code addresses for threaded code
