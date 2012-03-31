require 'formula'

class Renameutils < Formula
  url 'http://nongnu.uib.no/renameutils/renameutils-0.11.0.tar.gz'
  homepage 'http://www.nongnu.org/renameutils/'
  md5 'a3258f875d6077a06b6889de3a317dce'

  depends_on 'coreutils'

  def patches
      # renameutils requires GNU ls
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
diff --git a/src/list.c b/src/list.c
index 3c8ae58..4838c7a 100644
--- a/src/list.c
+++ b/src/list.c
@@ -419,7 +419,7 @@ run_ls(char **args, pid_t *ls_pid, int *ls_fd)
 	    die(_("cannot close file: %s"), errstr);
 	if (dup2(child_pipe[1], STDOUT_FILENO) == -1)
 	    die(_("cannot duplicate file descriptor: %s"), errstr);
-	execvp("ls", args);
+	execvp("gls", args);
 	die(_("cannot execute `ls': %s"), errstr);
     }
     *ls_pid = child_pid;
