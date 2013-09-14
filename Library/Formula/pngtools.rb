require 'formula'

class Pngtools < Formula
  homepage 'http://www.stillhq.com/pngtools/'
  # Version 0.4 is the current latest, but the upstream has pulled some useful
  # changes from Gentoo into the SVN that make it build nicely with libpng1.5
  url 'http://www.stillhq.com/svn/trunk/pngtools/', :using => :svn, :revision => 3378
  version '0.4'
  head 'http://www.stillhq.com/svn/trunk/pngtools/', :using => :svn

  depends_on :libpng

  def patches
    # Makefile.in patch could be accomplished with autotools, but that requires
    # several steps and having autotools installed, vs a quick patch...
    # pnginfo.c patch fixes a couple of minor bugs present in the upstream
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # To pass the test, we need to feed pnginfo a png file.  Steal one from Dock.app
    system 'pnginfo "`find /System/Library/CoreServices/Dock.app/Contents/Resources/*.png | head -1`"'
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 488aaf5..7f356af 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -57,10 +57,10 @@ pngchunks_LDADD = $(LDADD)
 am_pngcp_OBJECTS = pngcp.$(OBJEXT) pngread.$(OBJEXT) \
 	pngwrite.$(OBJEXT) inflateraster.$(OBJEXT)
 pngcp_OBJECTS = $(am_pngcp_OBJECTS)
-pngcp_LDADD = $(LDADD)
+pnginfo_LDADD = -lpng
 am_pnginfo_OBJECTS = pnginfo.$(OBJEXT)
 pnginfo_OBJECTS = $(am_pnginfo_OBJECTS)
-pnginfo_LDADD = $(LDADD)
+pngcp_LDADD = -lpng
 DEFAULT_INCLUDES = -I.@am__isrc@
 depcomp = $(SHELL) $(top_srcdir)/config/depcomp
 am__depfiles_maybe = depfiles
diff --git a/pnginfo.c b/pnginfo.c
index 9b17206..6c54ae3 100644
--- a/pnginfo.c
+++ b/pnginfo.c
@@ -127,6 +127,8 @@ main (int argc, char *argv[])
   // For each filename that we have:
   for (; i < argc; i++)
     pnginfo_displayfile (argv[i], extractBitmap, displayBitmap, tiffnames);
+
+  return 0;
 }
 
 void
@@ -309,11 +309,12 @@ pnginfo_displayfile (char *filename, int extractBitmap, int displayBitmap, int t
   printf ("  FillOrder: msb-to-lsb\n  Byte Order: Network (Big Endian)\n");
 
   png_textp text;
-  int num_text, max_text;
+  int num_text;
+  png_get_text(png, info, &text, &num_text);
 
   // Text comments
-  printf ("  Number of text strings: %d of %d\n",
-	  num_text, max_text);
+  printf ("  Number of text strings: %d\n",
+	  num_text);
 
   for (i = 0; i < num_text; i++)
     {
