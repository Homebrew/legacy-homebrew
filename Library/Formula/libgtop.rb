require 'formula'

class Libgtop < Formula
  homepage 'http://library.gnome.org/devel/libgtop/stable/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgtop/2.28/libgtop-2.28.4.tar.xz'
  md5 'c8aee3c9bde9033303147e993aa1b932'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'

  # Patch per MacPorts:
  # https://trac.macports.org/ticket/21165
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/sysdeps/darwin/proclist.c b/sysdeps/darwin/proclist.c
index 8cfb85d..27a1098 100644
--- a/sysdeps/darwin/proclist.c
+++ b/sysdeps/darwin/proclist.c
@@ -43,7 +43,7 @@ _glibtop_init_proclist_p (glibtop *server)
 
 pid_t *
 glibtop_get_proclist_p (glibtop *server, glibtop_proclist *buf,
-			int64_t which, int64_t arg)
+			gint64 which, gint64 arg)
 {
 	unsigned count, total, i;
 	pid_t *pids_chain;
