require 'formula'

class X11vnc < Formula
  homepage 'http://www.karlrunge.com/x11vnc/'
  url 'https://downloads.sourceforge.net/project/libvncserver/x11vnc/0.9.13/x11vnc-0.9.13.tar.gz'
  sha1 'f011d81488ac94dc8dce2d88739c23bd85a976fa'

  depends_on :x11 => :recommended
  depends_on 'jpeg'

  # Patch solid.c so a non-void function returns a NULL instead of a void.
  # An email has been sent to the maintainers about this issue.
  patch :DATA

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--mandir=#{man}"
    ]

    if build.with? 'x11'
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make"
    system "make", "MKDIRPROG=mkdir -p", "install"
  end

  test do
    system "#{bin}/x11vnc --version"
  end
end

__END__
diff --git a/x11vnc/solid.c b/x11vnc/solid.c
index d6b0bda..0b2cfa9 100644
--- a/x11vnc/solid.c
+++ b/x11vnc/solid.c
@@ -177,7 +177,7 @@ unsigned long get_pixel(char *color) {
 
 XImage *solid_root(char *color) {
 #if NO_X11
-	RAWFB_RET_VOID
+	RAWFB_RET(NULL)
 	if (!color) {}
 	return NULL;
 #else
