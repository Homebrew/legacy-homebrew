require 'formula'

class Xpdf < Formula
  homepage 'http://www.foolabs.com/xpdf/'
  url 'ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.03.tar.gz'
  md5 'af75f772bee0e5ae4a811ff9d03eac5a'

  depends_on 'lesstif'
  depends_on :x11

  # see: http://gnats.netbsd.org/45562
  def patches; DATA; end

  def install
<<<<<<< HEAD
    ENV.append_to_cflags "-I#{MacOS::XQuartz.include} -#{MacOS::XQuartz.include}/freetype2"
=======
    ENV.append_to_cflags "-I#{MacOS::X11.include} -#{MacOS::X11.include}/freetype2"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/xpdf/XPDFViewer.cc b/xpdf/XPDFViewer.cc
index 2de349d..e6ef7fa 100644
--- a/xpdf/XPDFViewer.cc
+++ b/xpdf/XPDFViewer.cc
@@ -1803,7 +1803,7 @@ void XPDFViewer::initToolbar(Widget parent) {
   menuPane = XmCreatePulldownMenu(toolBar, "zoomMenuPane", args, n);
   for (i = 0; i < nZoomMenuItems; ++i) {
     n = 0;
-    s = XmStringCreateLocalized(zoomMenuInfo[i].label);
+    s = XmStringCreateLocalized((char *)zoomMenuInfo[i].label);
     XtSetArg(args[n], XmNlabelString, s); ++n;
     XtSetArg(args[n], XmNuserData, (XtPointer)i); ++n;
     sprintf(buf, "zoom%d", i);
