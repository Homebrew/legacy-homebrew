require 'formula'

class Liblqr < Formula
  url 'http://liblqr.wikidot.com/local--files/en:download-page/liblqr-1-0.4.1.tar.bz2'
  homepage 'http://liblqr.wikidot.com/'
  sha1 '42b30b157b0c47690baa847847e24c7c94412b75'
  version '0.4.1'

  head 'git://repo.or.cz/liblqr.git'

  depends_on 'glib'

  def patches
    # fixes undefined reference to `lqr_pixel_get_rgbcol'
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/lqr/lqr_energy.c b/lqr/lqr_energy.c
index eb12c7b..a976c54 100644
--- a/lqr/lqr_energy.c
+++ b/lqr/lqr_energy.c
@@ -90,7 +90,7 @@ lqr_pixel_set_norm(gdouble val, void *rgb, gint rgb_ind, LqrColDepth col_depth)
     }
 }
 
-inline gdouble
+gdouble
 lqr_pixel_get_rgbcol(void *rgb, gint rgb_ind, LqrColDepth col_depth, LqrImageType image_type, gint channel)
 {
     gdouble black_fact = 0;
diff --git a/lqr/lqr_energy_priv.h b/lqr/lqr_energy_priv.h
index a5a498d..3644a0e 100644
--- a/lqr/lqr_energy_priv.h
+++ b/lqr/lqr_energy_priv.h
@@ -40,7 +40,7 @@
 
 inline gdouble lqr_pixel_get_norm(void *src, gint src_ind, LqrColDepth col_depth);
 inline void lqr_pixel_set_norm(gdouble val, void *rgb, gint rgb_ind, LqrColDepth col_depth);
-inline gdouble lqr_pixel_get_rgbcol(void *rgb, gint rgb_ind, LqrColDepth col_depth, LqrImageType image_type,
+gdouble lqr_pixel_get_rgbcol(void *rgb, gint rgb_ind, LqrColDepth col_depth, LqrImageType image_type,
                                     gint channel);
 inline gdouble lqr_carver_read_brightness_grey(LqrCarver *r, gint x, gint y);
 inline gdouble lqr_carver_read_brightness_std(LqrCarver *r, gint x, gint y);
