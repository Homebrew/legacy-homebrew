require 'formula'

class Liblqr < Formula
  url 'http://liblqr.wikidot.com/local--files/en:download-page/liblqr-1-0.4.1.tar.bz2'
  homepage 'http://liblqr.wikidot.com/'
  md5 '0e24ed3c9fcdcb111062640764d7b87a'
  version '0.4.1'

  depends_on 'glib'

  def patches
    # Fixes build problems on 10.5, MacPorts ticket 19685
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/lqr/lqr_energy_priv.h b/lqr/lqr_energy_priv.h
index a5a498d..dc0276d 100644
--- a/lqr/lqr_energy_priv.h
+++ b/lqr/lqr_energy_priv.h
@@ -45,9 +45,9 @@ inline gdouble lqr_pixel_get_rgbcol(void *rgb, gint rgb_ind, LqrColDepth col_dep
 inline gdouble lqr_carver_read_brightness_grey(LqrCarver *r, gint x, gint y);
 inline gdouble lqr_carver_read_brightness_std(LqrCarver *r, gint x, gint y);
 gdouble lqr_carver_read_brightness_custom(LqrCarver *r, gint x, gint y);
-inline gdouble lqr_carver_read_brightness(LqrCarver *r, gint x, gint y);
+gdouble lqr_carver_read_brightness(LqrCarver *r, gint x, gint y);
 inline gdouble lqr_carver_read_luma_std(LqrCarver *r, gint x, gint y);
-inline gdouble lqr_carver_read_luma(LqrCarver *r, gint x, gint y);
+gdouble lqr_carver_read_luma(LqrCarver *r, gint x, gint y);
 inline gdouble lqr_carver_read_rgba(LqrCarver *r, gint x, gint y, gint channel);
 inline gdouble lqr_carver_read_custom(LqrCarver *r, gint x, gint y, gint channel);
