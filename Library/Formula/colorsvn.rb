require 'formula'

class Colorsvn < Formula
  homepage 'http://colorsvn.tigris.org/'
  url 'http://www.console-colors.de/downloads/colorsvn/colorsvn-0.3.2.tar.gz'
  sha1 '8d9452585d474ad10e9e1fd2372f9ad41e548863'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    inreplace ["colorsvn.1", "colorsvn-original"], "/etc", etc
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    You probably want to set an alias to svn in your bash profile.
    So source #{etc}/profile.d/colorsvn-env.sh or add the line

        alias svn=colorsvn

    to your bash profile.

    So when you type "svn" you'll run "colorsvn".
    EOS
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 84a3d97..54c2f74 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -13,8 +13,6 @@ srcdir=@srcdir@
 mandir=@mandir@
 sysconfdir=@sysconfdir@
 
-confdir=/etc
-
 CP=@CP@
 PERL=@PERL@
 RM=@RM@ -f
@@ -36,10 +34,10 @@ colorsvn:
 install: colorsvn
 	$(INSTALL) -d $(DESTDIR)$(bindir) && \
 	$(INSTALL) -m 755 $(PACKAGE) $(DESTDIR)$(bindir)/$(PACKAGE) && \
-	$(INSTALL) -d $(DESTDIR)/$(confdir) && \
-	$(INSTALL) -m 644 $(CONFIGFILE) $(DESTDIR)/$(confdir)/$(CONFIGFILE) && \
-	$(INSTALL) -d $(DESTDIR)/$(confdir)/profile.d && \
-	$(INSTALL) -m 755 $(PROFFILE) $(DESTDIR)/$(confdir)/profile.d/$(PROFFILE) && \
+	$(INSTALL) -d $(DESTDIR)/$(sysconfdir) && \
+	$(INSTALL) -m 644 $(CONFIGFILE) $(DESTDIR)/$(sysconfdir)/$(CONFIGFILE) && \
+	$(INSTALL) -d $(DESTDIR)/$(sysconfdir)/profile.d && \
+	$(INSTALL) -m 755 $(PROFFILE) $(DESTDIR)/$(sysconfdir)/profile.d/$(PROFFILE) && \
 	if [ -f $(srcdir)/colorsvn.1 ] ; then \
 	    $(INSTALL) -d $(DESTDIR)$(mandir)/man1/ ; \
 	    $(INSTALL) -m 644 $(srcdir)/colorsvn.1 $(DESTDIR)$(mandir)/man1/ ; \
@@ -54,6 +52,6 @@ clean:
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(PACKAGE) && \
-	$(RM) $(DESTDIR)/$(confdir)/$(CONFIGFILE)  && \
-	$(RM) $(DESTDIR)/$(confdir)/profile.d/$(PROFFILE)
+	$(RM) $(DESTDIR)/$(sysconfdir)/$(CONFIGFILE)  && \
+	$(RM) $(DESTDIR)/$(sysconfdir)/profile.d/$(PROFFILE)
