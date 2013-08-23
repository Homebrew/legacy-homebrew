require 'formula'

class Pngtools < Formula
  homepage 'http://www.stillhq.com/pngtools/'
  # Version 0.4 is the current latest, but the upstream has pulled some useful changes from Gentoo into the SVN that make it build nicely with libpng1.5
  url 'http://www.stillhq.com/svn/trunk/pngtools/', :using => :svn, :revision => 3378
  version '0.4'
  # url 'http://www.stillhq.com/pngtools/source/pngtools_0_4.tgz'
  # sha1 'bc8b4953fbdf993f5837e2df510d2341e0ab7d54'
  head 'http://www.stillhq.com/svn/trunk/pngtools/', :using => :svn

  depends_on :libpng

  def patches
    # Could accomplish this with autotools, but that requires several steps and having autotools installed, vs a quick patch...
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
