require 'formula'

class Tmux < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.6/tmux-1.6.tar.gz'
  sha1 '8756f6bcecb18102b87e5d6f5952ba2541f68ed3'

  head 'https://tmux.svn.sourceforge.net/svnroot/tmux/trunk'

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  # This patch adds the implementation of osdep_get_cwd for Darwin platform,
  # so that tmux can get current working directory correctly under Mac OS.
  # NOTE: it applies to 1.6 only, and should be removed when 1.7 is out.
  #       (because it has been merged upstream)
  def patches
   DATA if build.stable?
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"

    (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux'

    # Install addtional meta file
    prefix.install 'NOTES'
  end

  def caveats; <<-EOS.undent
    Additional information can be found in:
      #{prefix}/NOTES
    EOS
  end

  def test
    system "#{bin}/tmux", "-V"
  end
end

__END__
diff --git a/osdep-darwin.c b/osdep-darwin.c
index c5820df..7b15446 100644
--- a/osdep-darwin.c
+++ b/osdep-darwin.c
@@ -18,6 +18,7 @@

 #include <sys/types.h>
 #include <sys/sysctl.h>
+#include <libproc.h>

 #include <event.h>
 #include <stdlib.h>
@@ -52,6 +53,15 @@
 char *
 osdep_get_cwd(pid_t pid)
 {
+	static char wd[PATH_MAX];
+	struct proc_vnodepathinfo pathinfo;
+	int ret;
+
+	ret = proc_pidinfo(pid, PROC_PIDVNODEPATHINFO, 0, &pathinfo, sizeof(pathinfo));
+	if (ret == sizeof(pathinfo)) {
+		strlcpy(wd, pathinfo.pvi_cdir.vip_path, sizeof(wd));
+		return (wd);
+	}
 	return (NULL);
 }
