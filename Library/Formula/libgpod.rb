require 'formula'

class Libgpod < Formula
  url 'http://downloads.sourceforge.net/project/gtkpod/libgpod/libgpod-0.8/libgpod-0.8.2.tar.bz2'
  homepage 'http://www.gtkpod.org/wiki/Libgpod'
  md5 'ff0fd875fa08f2a6a49dec57ce3367ab'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gdk-pixbuf'
  depends_on 'sqlite'

  def patches
    # patching sys/mount.h calls
    DATA
  end
  

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make all"
    system "make -C src install"
    bin.install [
      'tools/.libs',
      'tools/ipod-read-sysinfo-extended',
      'tools/ipod-set-info',
      'tools/iphone-set-info'
      ]
  end
end


__END__
diff --git a/tools/generic-callout.c b/tools/generic-callout.c
index 62bd08c..c6aa98b 100644
--- a/tools/generic-callout.c
+++ b/tools/generic-callout.c
@@ -601,7 +601,7 @@ static char *mount_ipod (const char *dev_path, const char *fstype)
                 return NULL;
         }
         g_assert (tmpname == filename);
-        result = mount (dev_path, tmpname, fstype, 0, NULL);
+        result = mount (dev_path, tmpname, 0, NULL);
         if (result != 0) {
                 g_debug("failed to mount device %s at %s: %s",
                         dev_path, tmpname, strerror(errno));
@@ -740,7 +740,7 @@ int itdb_callout_set_ipod_properties (ItdbBackend *backend, const char *dev,
          */
         mounted_ipod_set_properties (backend, ipod_mountpoint);
 
-        umount (ipod_mountpoint);
+        unmount (ipod_mountpoint, 0);
         g_rmdir (ipod_mountpoint);
         g_free (ipod_mountpoint);
