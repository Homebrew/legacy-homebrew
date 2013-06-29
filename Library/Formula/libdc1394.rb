require 'formula'

class Libdc1394 < Formula
  homepage 'http://damien.douxchamps.net/ieee1394/libdc1394/'
  url 'http://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.0/libdc1394-2.2.0.tar.gz'
  sha1 '7e831258a65e7e111a9d52d8062aec6d28a1e4c4'

  def patches
    # fix issue due to bug in OSX Firewire stack
    # libdc1394 author comments here:
    # http://permalink.gmane.org/gmane.comp.multimedia.libdc1394.devel/517
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-sdltest"
    system "make install"
  end
end


__END__
diff --git a/dc1394/macosx/capture.c b/dc1394/macosx/capture.c
index c7c71f2..8959535 100644
--- a/dc1394/macosx/capture.c
+++ b/dc1394/macosx/capture.c
@@ -150,7 +150,7 @@ callback (buffer_info * buffer, NuDCLRef dcl)
 
     for (i = 0; i < buffer->num_dcls; i++) {
         int packet_size = capture->frames[buffer->i].packet_size;
-        if ((buffer->pkts[i].status & 0x1F) != 0x11) {
+        if (buffer->pkts[i].status && (buffer->pkts[i].status & 0x1F) != 0x11) {
             dc1394_log_warning ("packet %d had error status %x",
                     i, buffer->pkts[i].status);
             corrupt = 1;
