require 'formula'

class Pan < Formula
  homepage 'http://pan.rebelbase.com/'
  url 'http://pan.rebelbase.com/download/releases/0.136/source/pan-0.136.tar.bz2'
  md5 '4b7f1f345797e44fe9c58f9c4480fa79'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'gmime'
  depends_on 'enchant' => :optional
  depends_on 'dbus' => :optional
  depends_on 'gnutls' => :optional

  def patches
    # Compilation fix; upstream bug reported at https://bugzilla.gnome.org/show_bug.cgi?id=673813
    { :p0 => DATA }
  end

  def install
    ENV.x11
    ENV.append 'LDFLAGS', ' -liconv ' # iconv detection is broken.

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -urN /tmp/pan-0.136-original/pan/gui/gui.cc pan/gui/gui.cc
--- /tmp/pan-0.136-original/pan/gui/gui.cc  2012-04-08 23:30:36.000000000 +0800
+++ pan/gui/gui.cc  2012-04-10 12:50:42.000000000 +0800
@@ -2171,8 +2171,8 @@
     g_snprintf (str, sizeof(str), "%s: %u/%u", _("Tasks"), running, size);

   // build the tooltip
-  gulong queued, unused, stopped;
-  guint64 KiB_remain;
+  unsigned long queued, unused, stopped;
+  uint64_t KiB_remain;
   double KiBps;
   int hr, min, sec;
   _queue.get_stats (queued, unused, stopped,
@@ -2180,7 +2180,7 @@
                     hr, min, sec);

   g_snprintf (tip, sizeof(tip), _("%lu tasks, %s, %.1f KiBps, ETA %d:%02d:%02d"),
-              (running+queued), render_bytes(KiB_remain), KiBps, hr, min, sec);
+              static_cast<gulong>(running+queued), render_bytes(static_cast<guint64>(KiB_remain)), KiBps, hr, min, sec);

   // update the gui
   gtk_label_set_text (GTK_LABEL(_queue_size_label), str);
