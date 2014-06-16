require 'formula'

class Bmon < Formula
  homepage 'http://people.suug.ch/~tgr/bmon'
  version '2.1.1-pre1'
  url 'http://ftp.ubuntu.com/ubuntu/pool/universe/b/bmon/bmon_2.1.1~pre1.orig.tar.gz'
  mirror 'http://ftp.gnome.org/mirror/ubuntu/pool/universe/b/bmon/bmon_2.1.1~pre1.orig.tar.gz'
  sha1 'd075dca44d7623b7d999f4c0160aa32284540703'

  # Patch to fix Grammar mistakes
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make" # two steps to prevent blowing up
    system "make install"
  end
end
__END__
diff --git a/src/out_xml_event.c b/src/out_xml_event.c
index ea2d71f..ac091b4 100644
--- a/src/out_xml_event.c
+++ b/src/out_xml_event.c
@@ -127,7 +127,7 @@ static struct output_module xml_event_ops = {
 	.om_draw = xml_event_draw,
 	.om_set_opts = xml_event_set_opts,
 	.om_probe = xml_event_probe,
-	.om_shutdown xml_event_shutdown,
+	.om_shutdown = xml_event_shutdown,
 };
 
 static void __init xml_event_init(void)
