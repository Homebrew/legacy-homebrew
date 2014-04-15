require 'formula'

class Readline < Formula
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'
  url 'http://ftpmirror.gnu.org/readline/readline-6.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz'
  sha256 '56ba6071b9462f980c5a72ab0023893b65ba6debb4eeb475d7a563dc65cafd43'
  version '6.3.3'

  bottle do
    cellar :any
    sha1 "0761dece1f4dfe3cec0e28f8edfb01366f2ca1d1" => :mavericks
    sha1 "996923feea4e1d2a227f4bb5883eee510d9b02b3" => :mountain_lion
    sha1 "a538a27da0497fd8e761b2639451fa171c20db30" => :lion
  end

  keg_only <<-EOS
OS X provides the BSD libedit library, which shadows libreadline.
In order to prevent conflicts when programs look for libreadline we are
defaulting this GNU Readline installation to keg-only.
EOS

  # Vendor the patches.
  # The mirrors are unreliable for getting the patches, and the more patches
  # there are, the more unreliable they get. Pulling this patch inline to
  # reduce bug reports.
  # Upstream patches can be found in:
  # http://git.savannah.gnu.org/cgit/readline.git
  patch :DATA

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--enable-multibyte"
    system "make install"

    # The 6.3 release notes say:
    #   When creating shared libraries on Mac OS X, the pathname written into the
    #   library (install_name) no longer includes the minor version number.
    # Software will link against libreadline.6.dylib instead of libreadline.6.3.dylib.
    # Therefore we create symlinks to avoid bumping the revisions on dependents.
    # This should be removed at 6.4.
    lib.install_symlink "libhistory.6.3.dylib" => "libhistory.6.2.dylib",
                        "libreadline.6.3.dylib" => "libreadline.6.2.dylib"
  end
end

__END__
diff --git a/patchlevel b/patchlevel
index e0ba09d..fdf4740 100644
--- a/patchlevel
+++ b/patchlevel
@@ -1,3 +1,3 @@
 # Do not edit -- exists only for use by patch
 
-5
+1
diff --git a/readline.c b/readline.c
index 03eefa6..eb4eae3 100644
--- a/readline.c
+++ b/readline.c
@@ -964,7 +964,7 @@ _rl_dispatch_subseq (key, map, got_subseq)
 #if defined (VI_MODE)
   if (rl_editing_mode == vi_mode && _rl_keymap == vi_movement_keymap &&
       key != ANYOTHERKEY &&
-      rl_key_sequence_length == 1 &&	/* XXX */
+      _rl_dispatching_keymap == vi_movement_keymap &&
       _rl_vi_textmod_command (key))
     _rl_vi_set_last (key, rl_numeric_arg, rl_arg_sign);
 #endif
diff --git a/patchlevel b/patchlevel
index fdf4740..7cbda82 100644
--- a/patchlevel
+++ b/patchlevel
@@ -1,3 +1,3 @@
 # Do not edit -- exists only for use by patch
 
-1
+2
diff --git a/readline.c b/readline.c
index eb4eae3..abb29a0 100644
--- a/readline.c
+++ b/readline.c
@@ -744,7 +744,8 @@ _rl_dispatch_callback (cxt)
     r = _rl_subseq_result (r, cxt->oldmap, cxt->okey, (cxt->flags & KSEQ_SUBSEQ));
 
   RL_CHECK_SIGNALS ();
-  if (r == 0)			/* success! */
+  /* We only treat values < 0 specially to simulate recursion. */
+  if (r >= 0 || (r == -1 && (cxt->flags & KSEQ_SUBSEQ) == 0))	/* success! or failure! */
     {
       _rl_keyseq_chain_dispose ();
       RL_UNSETSTATE (RL_STATE_MULTIKEY);
diff --git a/patchlevel b/patchlevel
index 7cbda82..ce3e355 100644
--- a/patchlevel
+++ b/patchlevel
@@ -1,3 +1,3 @@
 # Do not edit -- exists only for use by patch
 
-2
+3
diff --git a/util.c b/util.c
index fa3a667..58b55e2 100644
--- a/util.c
+++ b/util.c
@@ -476,6 +476,7 @@ _rl_savestring (s)
   return (strcpy ((char *)xmalloc (1 + (int)strlen (s)), (s)));
 }
 
+#if defined (DEBUG)
 #if defined (USE_VARARGS)
 static FILE *_rl_tracefp;
 
@@ -538,6 +539,7 @@ _rl_settracefp (fp)
   _rl_tracefp = fp;
 }
 #endif
+#endif /* DEBUG */
 
 
 #if HAVE_DECL_AUDIT_USER_TTY && defined (ENABLE_TTY_AUDIT_SUPPORT)
