require 'formula'

class Libdc1394 < Formula
  url 'http://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.1.4/libdc1394-2.1.4.tar.gz'
  homepage 'http://damien.douxchamps.net/ieee1394/libdc1394/'
  md5 'a9c5306dfc17917872513355f87e8412'

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    # fix issue due to bug in OSX Firewire stack
    # libdc1394 author comments here:
    # http://permalink.gmane.org/gmane.comp.multimedia.libdc1394.devel/517
    DATA
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
