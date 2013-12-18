require 'formula'

class Pan < Formula
  homepage 'http://pan.rebelbase.com/'
  url 'http://pan.rebelbase.com/download/releases/0.139/source/pan-0.139.tar.bz2'
  sha1 '01ea0361a6d81489888e6abb075fd552999c3c60'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gtk+'
  depends_on 'gmime'
  depends_on 'enchant' => :optional
  depends_on 'd-bus' => :optional
  depends_on 'gnutls' => :optional

  # Fix compilation on 64-bit; see https://bugzilla.gnome.org/show_bug.cgi?id=673813
  def patches; DATA end

  def install
    ENV.append 'LDFLAGS', ' -liconv ' # iconv detection is broken.

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-gtktest"
    system "make install"
  end
end

__END__
diff --git a/pan/gui/gui.cc b/pan/gui/gui.cc
index 2e01ae8..fa7d500 100644
--- a/pan/gui/gui.cc
+++ b/pan/gui/gui.cc
@@ -2223,8 +2223,8 @@ GUI :: set_queue_size_label (unsigned int running,
 
   // build the tooltip
   // todo : perhaps fix this for mac osx automatically....
-  gulong queued, unused, stopped;
-  guint64 KiB_remain;
+  unsigned long queued, unused, stopped;
+  uint64_t KiB_remain;
   double KiBps;
   int hr, min, sec;
   _queue.get_stats (queued, unused, stopped,
@@ -2232,7 +2232,7 @@ GUI :: set_queue_size_label (unsigned int running,
                     hr, min, sec);
 
   g_snprintf (tip, sizeof(tip), _("%lu tasks, %s, %.1f KiBps, ETA %d:%02d:%02d"),
-              (running+queued), render_bytes(KiB_remain), KiBps, hr, min, sec);
+              static_cast<gulong>(running+queued), render_bytes(static_cast<guint64>(KiB_remain)), KiBps, hr, min, sec);
 
   // update the gui
   gtk_label_set_text (GTK_LABEL(_queue_size_label), str);
