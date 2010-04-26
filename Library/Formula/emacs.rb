require 'formula'

class Magit <Formula
  url 'http://zagadka.vm.bytemark.co.uk/magit/magit-0.7.tar.gz'
  md5 '1ea442bd6f83f7ac82967059754c8c87'
  homepage 'http://zagadka.vm.bytemark.co.uk/magit/'
end

class Emacs <Formula
  # --cocoa implies --HEAD
  if not ARGV.include? "--cocoa"
    url 'http://ftp.gnu.org/pub/gnu/emacs/emacs-23.1.tar.bz2'
    md5 '17f7f0ba68a0432d58fa69d05a2225be'
  end
  if ARGV.include? "--use-git-head"
    head 'git://repo.or.cz/emacs.git'
  else
    head 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
  end
  homepage 'http://www.gnu.org/software/emacs/'

  def options
    [
      ["--cocoa", "Build a cocoa version of emacs (implies --HEAD)"],
      ["--use-git-head", "Use repo.or.cz git mirror for HEAD builds"],
    ]
  end

  def caveats
    "Use --cocoa to build a Cocoa binary Emacs.app from HEAD.

To access texinfo documentation, set your INFOPATH to:
#{info}

The Emacs project now uses bazaar for source code versioning. If you
last built the Homebrew emacs formula from HEAD (or with --cocoa)
prior to their switch from CVS to bazaar, you will have to remove your
emacs formula cache directory before building from HEAD again. The
Homebrew emacs cache directory can be found at
$HOME/Library/Caches/Homebrew/emacs-HEAD.

The initial checkout of the bazaar Emacs repository might take a long
time. You might find that using the repo.or.cz git mirror is faster,
even after the initial checkout. To use the repo.or.cz git mirror for
HEAD (or --cocoa) builds, use the --use-git-head option in addition to
--HEAD or --cocoa. Note that there is inevitably some lag between
checkins made to the official Emacs bazaar repository and their
appearance on the repo.or.cz mirror. See http://repo.or.cz/w/emacs.git
for the mirror's status. The Emacs devs do not provide support for the
git mirror, and they might reject bug reports filed with git version
information. Use it at your own risk.

If you switch between repositories, you'll have to remove the Homebrew
emacs cache directory (see above).
"
  end
  
  def patches
    if ARGV.include? "--cocoa"
      "http://dev.boris.com.au/emacs-23.1-CVS-Cocoa-homebrew.patch"
    elsif not ARGV.include? "--HEAD"
      DATA
    end
  end

  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--without-dbus",
      "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
    ]

    # segfault in --cocoa
    ENV.gcc_4_2

    if ARGV.include? "--cocoa"
      configure_args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *configure_args
      system "make bootstrap"
      system "make install"
      prefix.install "nextstep/Emacs.app"
    else
      configure_args << "--without-x"
      system "./configure", *configure_args
      system "make"
      system "make install"
    end

    Magit.new.brew do
      system "./configure", "--prefix=#{prefix}"
      system "make install"
    end
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

