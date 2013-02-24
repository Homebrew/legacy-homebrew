require 'formula'

class Readline < Formula
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'
  url 'http://ftpmirror.gnu.org/readline/readline-6.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/readline/readline-6.2.tar.gz'
  sha256 '79a696070a058c233c72dd6ac697021cc64abd5ed51e59db867d66d196a89381'
  version '6.2.4'

  keg_only <<-EOS
OS X provides the BSD libedit library, which shadows libreadline.
In order to prevent conflicts when programs look for libreadline we are
defaulting this GNU Readline installation to keg-only.
EOS

<<<<<<< HEAD
<<<<<<< HEAD
  def patches
    {:p0 => [
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-001",
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-002",
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-003",
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-004"
      ]}
  end
=======
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
  # Vendor the patches.
  # The mirrors are unreliable for getting the patches, and the more patches
  # there are, the more unreliable they get. Pulling this patch inline to
  # reduce bug reports.
  # Upstream patches can be found in:
  # http://ftpmirror.gnu.org/readline/readline-6.2-patches
  def patches; DATA; end
<<<<<<< HEAD
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  def install
    # Always build universal, per https://github.com/mxcl/homebrew/issues/issue/899
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-multibyte"
    system "make install"
  end
end

__END__
diff --git a/callback.c b/callback.c
index 4ee6361..7682cd0 100644
--- a/callback.c
+++ b/callback.c
@@ -148,6 +148,9 @@ rl_callback_read_char ()
 	  eof = _rl_vi_domove_callback (_rl_vimvcxt);
 	  /* Should handle everything, including cleanup, numeric arguments,
 	     and turning off RL_STATE_VIMOTION */
+	  if (RL_ISSTATE (RL_STATE_NUMERICARG) == 0)
+	    _rl_internal_char_cleanup ();
+
 	  return;
 	}
 #endif
diff --git a/input.c b/input.c
index 7c74c99..b49af88 100644
--- a/input.c
+++ b/input.c
@@ -409,7 +409,7 @@ rl_clear_pending_input ()
 int
 rl_read_key ()
 {
-  int c;
+  int c, r;
 
   rl_key_sequence_length++;
 
@@ -429,14 +429,18 @@ rl_read_key ()
 	{
 	  while (rl_event_hook)
 	    {
-	      if (rl_gather_tyi () < 0)	/* XXX - EIO */
+	      if (rl_get_char (&c) != 0)
+		break;
+		
+	      if ((r = rl_gather_tyi ()) < 0)	/* XXX - EIO */
 		{
 		  rl_done = 1;
 		  return ('\n');
 		}
+	      else if (r == 1)			/* read something */
+		continue;
+
 	      RL_CHECK_SIGNALS ();
-	      if (rl_get_char (&c) != 0)
-		break;
 	      if (rl_done)		/* XXX - experimental */
 		return ('\n');
 	      (*rl_event_hook) ();
diff --git a/patchlevel b/patchlevel
index fdf4740..626a945 100644
--- a/patchlevel
+++ b/patchlevel
@@ -1,3 +1,3 @@
 # Do not edit -- exists only for use by patch
 
-1
+4
diff --git a/support/shobj-conf b/support/shobj-conf
index 5a63e80..c61dc78 100644
--- a/support/shobj-conf
+++ b/support/shobj-conf
@@ -157,7 +157,7 @@ freebsd[4-9]*|freebsdelf*|dragonfly*)
 	;;
 
 # Darwin/MacOS X
-darwin[89]*|darwin10*)
+darwin[89]*|darwin1[012]*)
 	SHOBJ_STATUS=supported
 	SHLIB_STATUS=supported
 	
@@ -186,7 +186,7 @@ darwin*|macosx*)
 	SHLIB_LIBSUFF='dylib'
 
 	case "${host_os}" in
-	darwin[789]*|darwin10*)	SHOBJ_LDFLAGS=''
+	darwin[789]*|darwin1[012]*)	SHOBJ_LDFLAGS=''
 			SHLIB_XLDFLAGS='-dynamiclib -arch_only `/usr/bin/arch` -install_name $(libdir)/$@ -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR) -compatibility_version $(SHLIB_MAJOR) -v'
 			;;
 	*)		SHOBJ_LDFLAGS='-dynamic'
diff --git a/vi_mode.c b/vi_mode.c
index 41e1dbb..4408053 100644
--- a/vi_mode.c
+++ b/vi_mode.c
@@ -1114,7 +1114,7 @@ rl_domove_read_callback (m)
       rl_beg_of_line (1, c);
       _rl_vi_last_motion = c;
       RL_UNSETSTATE (RL_STATE_VIMOTION);
-      return (0);
+      return (vidomove_dispatch (m));
     }
 #if defined (READLINE_CALLBACKS)
   /* XXX - these need to handle rl_universal_argument bindings */
@@ -1234,11 +1234,19 @@ rl_vi_delete_to (count, key)
       _rl_vimvcxt->motion = '$';
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
-  else if (vi_redoing)
+  else if (vi_redoing && _rl_vi_last_motion != 'd')	/* `dd' is special */
     {
       _rl_vimvcxt->motion = _rl_vi_last_motion;
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
+  else if (vi_redoing)		/* handle redoing `dd' here */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      rl_mark = rl_end;
+      rl_beg_of_line (1, key);
+      RL_UNSETSTATE (RL_STATE_VIMOTION);
+      r = vidomove_dispatch (_rl_vimvcxt);
+    }
 #if defined (READLINE_CALLBACKS)
   else if (RL_ISSTATE (RL_STATE_CALLBACK))
     {
@@ -1316,11 +1324,19 @@ rl_vi_change_to (count, key)
       _rl_vimvcxt->motion = '$';
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
-  else if (vi_redoing)
+  else if (vi_redoing && _rl_vi_last_motion != 'c')	/* `cc' is special */
     {
       _rl_vimvcxt->motion = _rl_vi_last_motion;
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
+  else if (vi_redoing)		/* handle redoing `cc' here */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      rl_mark = rl_end;
+      rl_beg_of_line (1, key);
+      RL_UNSETSTATE (RL_STATE_VIMOTION);
+      r = vidomove_dispatch (_rl_vimvcxt);
+    }
 #if defined (READLINE_CALLBACKS)
   else if (RL_ISSTATE (RL_STATE_CALLBACK))
     {
@@ -1377,6 +1393,19 @@ rl_vi_yank_to (count, key)
       _rl_vimvcxt->motion = '$';
       r = rl_domove_motion_callback (_rl_vimvcxt);
     }
+  else if (vi_redoing && _rl_vi_last_motion != 'y')	/* `yy' is special */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      r = rl_domove_motion_callback (_rl_vimvcxt);
+    }
+  else if (vi_redoing)			/* handle redoing `yy' here */
+    {
+      _rl_vimvcxt->motion = _rl_vi_last_motion;
+      rl_mark = rl_end;
+      rl_beg_of_line (1, key);
+      RL_UNSETSTATE (RL_STATE_VIMOTION);
+      r = vidomove_dispatch (_rl_vimvcxt);
+    }
 #if defined (READLINE_CALLBACKS)
   else if (RL_ISSTATE (RL_STATE_CALLBACK))
     {
