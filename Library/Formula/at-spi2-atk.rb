require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.6/at-spi2-atk-2.6.2.tar.xz'
  sha256 '496c8432e8ab82735145f9af5d45209e9b708bf3c94e527ee091d08641a9bcfa'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'at-spi2-core'
  depends_on 'atk'

  # Suppress a "non-void function should return a value" error, fixed upstream
  def patches; DATA end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/atk-adaptor/accessible-cache.c b/atk-adaptor/accessible-cache.c
index be247e4..62566b8 100644
--- a/atk-adaptor/accessible-cache.c
+++ b/atk-adaptor/accessible-cache.c
@@ -362,7 +362,7 @@ child_added_listener (GSignalInvocationHint * signal_hint,
           if (!child)
             {
               g_static_rec_mutex_unlock (&cache_mutex);
-              return;
+              return TRUE;
             }
 
           g_object_ref (child);

