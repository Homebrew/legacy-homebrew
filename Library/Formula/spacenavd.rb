class Spacenavd < Formula
  desc "Userspace device driver/daemon for 3Dconnexion's 3D input devices."
  homepage "http://spacenav.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/spacenav/spacenav%20daemon/spacenavd%200.6/spacenavd-0.6.tar.gz"
  sha256 "c2d203bf96c5a959590146a43fe5d6e5e8c5c38a8b2f55aa199d967d0d88d0ab"

  option "with-x11", "Enable support for x11 communication."

  depends_on :x11 => :optional

  # There is a ticket filed for this project on sourceforge to fix this:
  # https://sourceforge.net/p/spacenav/bugs/10/
  patch :DATA

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--disable-x11" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "spacenavd", "-h"
  end
end

__END__
diff --git a/src/dev_usb_darwin.c b/src/dev_usb_darwin.c
index 0849f80..cd98ca8 100644
--- a/src/dev_usb_darwin.c
+++ b/src/dev_usb_darwin.c
@@ -23,6 +23,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <IOKit/hid/IOHIDLib.h>
 #include "dev.h"
 #include "dev_usb.h"
+#include "spnavd.h"
 
 int open_dev_usb(struct device *dev)
 {
