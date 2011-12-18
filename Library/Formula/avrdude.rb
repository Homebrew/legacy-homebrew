require 'formula'

class Avrdude < Formula
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.1.tar.gz'
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  md5 '3a43e288cb32916703b6945e3f260df9'

  depends_on 'libusb-compat' if ARGV.include? '--with-usb'

  def options
    [['--with-usb', 'Compile AVRDUDE with USB support.']]
  end

  def patches; DATA; end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/usb_libusb.c b/usb_libusb.c
index c61bdbd..d72bbb9 100644
--- a/usb_libusb.c
+++ b/usb_libusb.c
@@ -444,14 +444,19 @@ static int usbdev_drain(union filedescriptor *fd, int display)
   usb_dev_handle *udev = (usb_dev_handle *)fd->usb.handle;
   int rv;
 
+  /*
+   * On some USB devices (specifically LUFA based AVRISPmkII's
+   * this actually causes a problem and doesn't appear to be
+   * required on USB anyway.
+   */
+  return 0;
+
   do {
     rv = usb_bulk_read(udev, fd->usb.ep, usbbuf, USBDEV_MAX_XFER, 100);
     if (rv > 0 && verbose >= 4)
       fprintf(stderr, "%s: usbdev_drain(): flushed %d characters\n",
 	      progname, rv);
   } while (rv > 0);
-
-  return 0;
 }
 
 /*
