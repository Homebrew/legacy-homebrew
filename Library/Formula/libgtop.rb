require 'formula'

class Libgtop <Formula
  url 'ftp://ftp.gnome.org/pub/gnome/sources/libgtop/2.28/libgtop-2.28.1.tar.gz'
  homepage 'http://library.gnome.org/devel/libgtop/stable/'
  md5 'a035abf8cf7877a9950b6483aa7b96fd'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'

  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
