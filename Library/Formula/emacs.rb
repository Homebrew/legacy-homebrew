require 'brewkit'

class Emacs <Formula
  head 'git://git.savannah.gnu.org/emacs.git'
  url 'http://ftp.gnu.org/pub/gnu/emacs/emacs-23.1.tar.bz2'
  homepage 'http://www.gnu.org/software/emacs/'
  md5 '17f7f0ba68a0432d58fa69d05a2225be'
  
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
			  "--disable-debug",
			  "--disable-dependency-tracking",
			  "--without-x"
    system "make; make install"
  end
end

__END__
From c9c5cb64cafe47911dfd32c04819543ac9a57baa Mon Sep 17 00:00:00 2001
From: YAMAMOTO Mitsuharu <mituharu@math.s.chiba-u.ac.jp>
Date: Fri, 28 Aug 2009 22:49:46 +0000
Subject: [PATCH 001/720] (print_load_command_name) [LC_DYLD_INFO]: Add cases
 LC_DYLD_INFO and LC_DYLD_INFO_ONLY.
 (copy_data_segment): Also copy __program_vars section.
 (copy_dyld_info) [LC_DYLD_INFO]: New function.
 (dump_it) [LC_DYLD_INFO]: Use it.

---
 src/unexmacosx.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/src/unexmacosx.c b/src/unexmacosx.c
index ff6ab01..bb71d8f 100644
--- a/src/unexmacosx.c
+++ b/src/unexmacosx.c
@@ -582,6 +582,14 @@ print_load_command_name (int lc)
       printf ("LC_UUID          ");
       break;
 #endif
+#ifdef LC_DYLD_INFO
+    case LC_DYLD_INFO:
+      printf ("LC_DYLD_INFO     ");
+      break;
+    case LC_DYLD_INFO_ONLY:
+      printf ("LC_DYLD_INFO_ONLY");
+      break;
+#endif
     default:
       printf ("unknown          ");
     }
@@ -819,6 +827,7 @@ copy_data_segment (struct load_command *lc)
 	       || strncmp (sectp->sectname, "__const", 16) == 0
 	       || strncmp (sectp->sectname, "__cfstring", 16) == 0
 	       || strncmp (sectp->sectname, "__gcc_except_tab", 16) == 0
+	       || strncmp (sectp->sectname, "__program_vars", 16) == 0
 	       || strncmp (sectp->sectname, "__objc_", 7) == 0)
 	{
 	  if (!unexec_copy (sectp->offset, old_file_offset, sectp->size))
@@ -1086,6 +1095,36 @@ copy_twolevelhints (struct load_command *lc, long delta)
   curr_header_offset += lc->cmdsize;
 }
 
+#ifdef LC_DYLD_INFO
+/* Copy a LC_DYLD_INFO(_ONLY) load command from the input file to the output
+   file, adjusting the file offset fields.  */
+static void
+copy_dyld_info (struct load_command *lc, long delta)
+{
+  struct dyld_info_command *dip = (struct dyld_info_command *) lc;
+
+  if (dip->rebase_off > 0)
+    dip->rebase_off += delta;
+  if (dip->bind_off > 0)
+    dip->bind_off += delta;
+  if (dip->weak_bind_off > 0)
+    dip->weak_bind_off += delta;
+  if (dip->lazy_bind_off > 0)
+    dip->lazy_bind_off += delta;
+  if (dip->export_off > 0)
+    dip->export_off += delta;
+
+  printf ("Writing ");
+  print_load_command_name (lc->cmd);
+  printf (" command\n");
+
+  if (!unexec_write (curr_header_offset, lc, lc->cmdsize))
+    unexec_error ("cannot write dyld info command to header");
+
+  curr_header_offset += lc->cmdsize;
+}
+#endif
+
 /* Copy other kinds of load commands from the input file to the output
    file, ones that do not require adjustments of file offsets.  */
 static void
@@ -1152,6 +1191,12 @@ dump_it ()
       case LC_TWOLEVEL_HINTS:
 	copy_twolevelhints (lca[i], linkedit_delta);
 	break;
+#ifdef LC_DYLD_INFO
+      case LC_DYLD_INFO:
+      case LC_DYLD_INFO_ONLY:
+	copy_dyld_info (lca[i], linkedit_delta);
+	break;
+#endif
       default:
 	copy_other (lca[i]);
 	break;
-- 
1.6.4.4

From 27497ca658b5717792c769eed48f036c1dc24b75 Mon Sep 17 00:00:00 2001
From: YAMAMOTO Mitsuharu <mituharu@math.s.chiba-u.ac.jp>
Date: Fri, 28 Aug 2009 22:49:58 +0000
Subject: [PATCH 001/719] [temacs] Undef HAVE_POSIX_MEMALIGN.

---
 src/s/darwin.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/src/s/darwin.h b/src/s/darwin.h
index da223e9..40aa583 100644
--- a/src/s/darwin.h
+++ b/src/s/darwin.h
@@ -171,6 +171,9 @@ along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.  */
 #define malloc unexec_malloc
 #define realloc unexec_realloc
 #define free unexec_free
+/* Don't use posix_memalign because it is not compatible with
+   unexmacosx.c.  */
+#undef HAVE_POSIX_MEMALIGN
 #endif
 
 /* The ncurses library has been moved out of the System framework in
-- 
1.6.4.4

