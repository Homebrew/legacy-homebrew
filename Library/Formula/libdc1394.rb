require 'formula'

class Libdc1394 < Formula
  homepage 'http://damien.douxchamps.net/ieee1394/libdc1394/'
  url 'https://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.1/libdc1394-2.2.1.tar.gz'
  sha1 'b92c9670b68c4e5011148f16c87532bef2e5b808'

  depends_on :libtool
  depends_on :automake
  depends_on :autoconf
  depends_on 'sdl'

  # fix issue due to bug in OSX Firewire stack
  # libdc1394 author comments here:
  # http://permalink.gmane.org/gmane.comp.multimedia.libdc1394.devel/517
  patch :DATA

  # Backport of upstream fixes for building on OS X
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7395159/raw/3ba722636fb898d210170f5d8a494977c89626b7/libdc1394.patch"
    sha1 "832869d05dabf8d62c1a5ac1b10a94fb7b7755c5"
  end

  def install
    system "autoreconf", "-fvi"
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
