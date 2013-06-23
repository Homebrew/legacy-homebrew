require 'formula'

class Tmux < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.8/tmux-1.8.tar.gz'
  sha1 '08677ea914e1973ce605b0008919717184cbd033'

  head 'git://tmux.git.sourceforge.net/gitroot/tmux/tmux'

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def patches
    # Fixes installation failure on Snow Leopard
    # http://sourceforge.net/mailarchive/forum.php?thread_name=CAJfQvvc2QDU%3DtXWb-sc-NK0J8cgnDRMDod6CNKO1uYqu%3DY5CXg%40mail.gmail.com&forum_name=tmux-users
    # http://sourceforge.net/p/tmux/tickets/41/
    # Fixes abnormal displaying Korean letters on Mac OS X
    # https://gist.github.com/niceview/5343842
    # Accepted upstream, can be removedin next version.
    DATA
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"

    bash_completion.install "examples/bash_completion_tmux.sh" => 'tmux'
  end

  def test
    system "#{bin}/tmux", "-V"
  end
end

__END__
diff --git a/osdep-darwin.c b/osdep-darwin.c
index 23de9d5..b5efe84 100644
--- a/osdep-darwin.c
+++ b/osdep-darwin.c
@@ -33,17 +33,17 @@ struct event_base	*osdep_event_init(void);
 char *
 osdep_get_name(int fd, unused char *tty)
 {
-	struct proc_bsdshortinfo	bsdinfo;
+	struct proc_bsdinfo bsdinfo;
	pid_t				pgrp;
	int				ret;

	if ((pgrp = tcgetpgrp(fd)) == -1)
		return (NULL);

-	ret = proc_pidinfo(pgrp, PROC_PIDT_SHORTBSDINFO, 0,
+	ret = proc_pidinfo(pgrp, PROC_PIDTBSDINFO, 0,
	    &bsdinfo, sizeof bsdinfo);
-	if (ret == sizeof bsdinfo && *bsdinfo.pbsi_comm != '\0')
-		return (strdup(bsdinfo.pbsi_comm));
+	if (ret == sizeof bsdinfo && *bsdinfo.pbi_comm != '\0')
+		return (strdup(bsdinfo.pbi_comm));
	return (NULL);
 }

diff --git a/utf8.c b/utf8.c
index 88d847a..34e5087 100644
--- a/utf8.c
+++ b/utf8.c
@@ -173,7 +173,7 @@ struct utf8_width_entry utf8_width_table[] = {
	{ 0x30000, 0x3fffd, 2, NULL, NULL },
	{ 0x00711, 0x00711, 0, NULL, NULL },
	{ 0x0fe00, 0x0fe0f, 0, NULL, NULL },
-	{ 0x01160, 0x011ff, 0, NULL, NULL },
+	{ 0x01160, 0x011ff, 1, NULL, NULL },
	{ 0x0180b, 0x0180d, 0, NULL, NULL },
	{ 0x10a3f, 0x10a3f, 0, NULL, NULL },
	{ 0x00981, 0x00981, 0, NULL, NULL },
