require 'formula'

class Renameutils < Formula
  url 'http://nongnu.uib.no/renameutils/renameutils-0.10.0.tar.gz'
  homepage 'http://www.nongnu.org/renameutils/'
  md5 '77f2bb9a18bb25c7cc3c23b64f2d394b'

  depends_on 'coreutils'

  def patches
    # use coreutils mv and cp since renameutils does not work with
    # those provided by os x
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
  end
end

__END__
from evangoldenberg@gmail.com via <https://trac.macports.org/ticket/24525>
--- a/src/apply.c
+++ b/src/apply.c
@@ -72,9 +72,9 @@ perform_command(FileSpec *spec)
     if (force_command != NULL)
         command = force_command;
     else if (strcmp(program, "qmv") == 0)
-        command = "mv";
+        command = "gmv";
     else
-        command = "cp";
+        command = "gcp";

     child = fork();
     if (child < 0) {
--- a/src/icmd.c
+++ b/src/icmd.c
@@ -45,8 +45,8 @@
 #include "common/string-utils.h"
 #include "common/common.h"

-#define MV_COMMAND "mv"
-#define CP_COMMAND "cp"
+#define MV_COMMAND "gmv"
+#define CP_COMMAND "gcp"
 /* This list should be up to date with mv and cp!
  * It was last updated on 2007-11-30 for
  * Debian coreutils 5.97-5.4 in unstable.
--- a/src/list.c
+++ b/src/list.c
@@ -311,7 +311,7 @@ list_files(char **args)
     ls_args_list = llist_clone(ls_options);	/* llist_add_all! */
     llist_add_last(ls_args_list, "--");
     llist_add_first(ls_args_list, "--quoting-style=c");
-    llist_add_first(ls_args_list, "ls");
+    llist_add_first(ls_args_list, "gls");

     if (llist_contains(ls_options, "--directory")) {
 	firstdir = ".";
@@ -411,7 +411,7 @@ run_ls(char **args, pid_t *ls_pid, int *ls_fd)
 	    die(_("cannot close file: %s"), errstr);
 	if (dup2(child_pipe[1], STDOUT_FILENO) == -1)
 	    die(_("cannot duplicate file descriptor: %s"), errstr);
-	execvp("ls", args);
+	execvp("gls", args);
 	die(_("cannot execute `ls': %s"), errstr);
     }
     *ls_pid = child_pid;
