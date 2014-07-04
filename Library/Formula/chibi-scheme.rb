require 'formula'

class ChibiScheme < Formula
  homepage 'http://code.google.com/p/chibi-scheme/'
  url 'http://abrek.synthcode.com/chibi-scheme-0.7.tgz'
  sha1 'e751a1881138ddba7caf170859e30dcfeba1a177'
  head 'https://code.google.com/p/chibi-scheme/', :using => :hg

  bottle do
    sha1 "e5f0e061820123d56736261e3f04907bf5c63ce8" => :mavericks
    sha1 "fd04e7f93c4b5bcc416ace19d80f7766c41a3afe" => :mountain_lion
    sha1 "7111751abca30c0a77c8130bd87f082cea255bdd" => :lion
  end

  # Remove after upstream fixes this issue
  # https://code.google.com/p/chibi-scheme/issues/detail?id=227
  patch :DATA unless build.head?

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = `#{bin}/chibi-scheme -mchibi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $?.exitstatus
  end
end

__END__
diff --git a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -102,13 +102,13 @@
 libchibi-sexp$(SO): $(SEXP_OBJS)
	$(CC) $(CLIBFLAGS) $(CLINKFLAGS) -o $@ $^ $(XLDFLAGS)

-libchibi-scheme$(SO).$(SOVERSION): $(SEXP_OBJS) $(EVAL_OBJS)
+libchibi-scheme$(SO_VERSIONED_SUFFIX): $(SEXP_OBJS) $(EVAL_OBJS)
	$(CC) $(CLIBFLAGS) $(CLINKFLAGS) $(LIBCHIBI_FLAGS) -o $@ $^ $(XLDFLAGS)

-libchibi-scheme$(SO).$(SOVERSION_MAJOR): libchibi-scheme$(SO).$(SOVERSION)
+libchibi-scheme$(SO_MAJOR_VERSIONED_SUFFIX): libchibi-scheme$(SO_VERSIONED_SUFFIX)
	$(LN) -sf $< $@

-libchibi-scheme$(SO): libchibi-scheme$(SO).$(SOVERSION_MAJOR)
+libchibi-scheme$(SO): libchibi-scheme$(SO_MAJOR_VERSIONED_SUFFIX)
	$(LN) -sf $< $@

 libchibi-scheme.a: $(SEXP_OBJS) $(EVAL_OBJS)
@@ -331,9 +331,9 @@
	$(INSTALL) -m0644 $(INCLUDES) $(DESTDIR)$(INCDIR)/
	$(MKDIR) $(DESTDIR)$(LIBDIR)
	$(MKDIR) $(DESTDIR)$(SOLIBDIR)
-	$(INSTALL) -m0644 libchibi-scheme$(SO).$(SOVERSION) $(DESTDIR)$(SOLIBDIR)/
-	$(LN) -s -f $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO).$(SOVERSION) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO).$(SOVERSION_MAJOR)
-	$(LN) -s -f $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO).$(SOVERSION) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO)
+	$(INSTALL) -m0644 libchibi-scheme$(SO_VERSIONED_SUFFIX) $(DESTDIR)$(SOLIBDIR)/
+	$(LN) -s -f $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO_VERSIONED_SUFFIX) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO_MAJOR_VERSIONED_SUFFIX)
+	$(LN) -s -f $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO_VERSIONED_SUFFIX) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO)
	-$(INSTALL) -m0644 libchibi-scheme.a $(DESTDIR)$(SOLIBDIR)/
	$(MKDIR) $(DESTDIR)$(SOLIBDIR)/pkgconfig
	$(INSTALL) -m0644 chibi-scheme.pc $(DESTDIR)$(SOLIBDIR)/pkgconfig/
@@ -350,8 +350,8 @@
	-$(RM) $(DESTDIR)$(BINDIR)/chibi-doc
	-$(RM) $(DESTDIR)$(BINDIR)/snow-chibi
	-$(RM) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO)
-	-$(RM) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO).$(SOVERSION)
-	-$(RM) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO).$(SOVERSION_MAJOR)
+	-$(RM) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO_VERSIONED_SUFFIX)
+	-$(RM) $(DESTDIR)$(SOLIBDIR)/libchibi-scheme$(SO_MAJOR_VERSIONED_SUFFIX)
	-$(RM) $(DESTDIR)$(LIBDIR)/libchibi-scheme$(SO).a
	-$(RM) $(DESTDIR)$(SOLIBDIR)/pkgconfig/chibi-scheme.pc
	-$(CD) $(DESTDIR)$(INCDIR) && $(RM) $(INCLUDES)
diff --git a/Makefile.detect b/Makefile.detect
--- a/Makefile.detect
+++ b/Makefile.detect
@@ -46,14 +46,18 @@
 # Set default variables for the platform.

 LIBDL = -ldl
+SO_VERSIONED_SUFFIX = $(SO).$(SOVERSION)
+SO_MAJOR_VERSIONED_SUFFIX = $(SO).$(SOVERSION_MAJOR)

 ifeq ($(PLATFORM),macosx)
 SO  = .dylib
+SO_VERSIONED_SUFFIX = .$(SOVERSION)$(SO)
+SO_MAJOR_VERSIONED_SUFFIX = .$(SOVERSION_MAJOR)$(SO)
 EXE =
 CLIBFLAGS =
 CLINKFLAGS = -dynamiclib
 STATICFLAGS = -static-libgcc -DSEXP_USE_DL=0
-LIBCHIBI_FLAGS = -install_name $(DESTDIR)$(SOLIBDIR)/libchibi-scheme.dylib.$(SOVERSION)
+LIBCHIBI_FLAGS = -install_name $(DESTDIR)$(SOLIBDIR)/libchibi-scheme.$(SOVERSION).dylib
 else
 ifeq ($(PLATFORM),bsd)
 SO  = .so
