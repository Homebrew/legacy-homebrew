class Colorsvn < Formula
  desc "Subversion output colorizer"
  homepage "http://colorsvn.tigris.org/"
  url "http://colorsvn.tigris.org/files/documents/4414/49311/colorsvn-0.3.3.tar.gz"
  sha256 "db58d5b8f60f6d4def14f8f102ff137b87401257680c1acf2bce5680b801394e"
  revision 1

  bottle do
    sha256 "30d9da7a1ce1c1cdb42dd6e83cd51e8dfd7b1706ee1ce5752207a28b97306e1f" => :yosemite
    sha256 "94330b9473fc8f615bb3244a767ed44409e8e80b58500b7c85b4cca8f0cdaafe" => :mavericks
    sha256 "9e81200ceb3a34f741eb7faadf1616cb0d9878599fdfb2d6b01b2e09d9b33c9f" => :mountain_lion
  end

  patch :DATA

  def install
    # `configure` uses `which` to find the `svn` binary that is then hard-coded
    # into the `colorsvn` binary and its configuration file. Unfortunately, this
    # picks up our SCM wrapper from `Library/ENV/` that is not supposed to be
    # used outside of our build process. Do the lookup ourselves to fix that.
    svn_binary = which_all("svn").reject do |bin|
      bin.to_s.start_with?("#{HOMEBREW_REPOSITORY}/Library/ENV/")
    end.first
    inreplace ["configure", "configure.in"], "\nORIGSVN=`which svn`",
                                             "\nORIGSVN=#{svn_binary}"

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    inreplace ["colorsvn.1", "colorsvn-original"], "/etc", etc
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You probably want to set an alias to svn in your bash profile.
    So source #{etc}/profile.d/colorsvn-env.sh or add the line

        alias svn=colorsvn

    to your bash profile.

    So when you type "svn" you'll run "colorsvn".
    EOS
  end

  test do
    assert_match /svn: E155007/, shell_output("#{bin}/colorsvn info 2>&1", 1)
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
