require 'formula'

class Mspdebug <Formula
  url 'http://downloads.sourceforge.net/project/mspdebug/mspdebug-0.10.tar.gz'
  md5 '6537f6666451a82422d6a5b01ba48e9c'
  homepage 'http://mspdebug.sf.net/'
  head 'git://mspdebug.git.sourceforge.net/gitroot/mspdebug/mspdebug'

  depends_on 'libusb'
  depends_on 'libusb-compat'
  depends_on 'libelf'

  def patches
    # Without this patch, mspdebug hangs when trying
    # to open a connection to a TI LaunchPad.
    # see: http://e2e.ti.com/support/microcontrollers/msp43016-bit_ultra-low_power_mcus/f/166/p/18554/212659.aspx#212659
    DATA
  end

  def install
    ENV["PREFIX"] = prefix
    inreplace "Makefile", "/opt", "/usr" # Don't assume MacPorts. (May not be necessary.)
    system "make install"
  end

  def caveats
    <<-EOS.undent
        If you're using a RF2500-like device like the TI LaunchPad, you must
        install a codeless kext for the device to be recognized by mspdebug.

        More information is available at http://mspdebug.sourceforge.net/download.html.
    EOS
  end
end

__END__
diff --git a/rf2500.c b/rf2500.c
index ac27dcd..70a69b8 100644
--- a/rf2500.c
+++ b/rf2500.c
@@ -212,10 +212,5 @@ transport_t rf2500_open(const char *devpath)
 		return NULL;
 	}
 
-	/* Flush out lingering data */
-	while (usb_bulk_read(tr->handle, USB_FET_IN_EP,
-			     buf, sizeof(buf),
-			     100) >= 0);
-
 	return (transport_t)tr;
 }
