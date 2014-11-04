require "formula"

# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  homepage "https://www.gnu.org/software/libtool/"
  url "http://ftpmirror.gnu.org/libtool/libtool-2.4.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.3.tar.xz"
  sha1 "7e946bd07b846a8803bf4321e82cd6be8059c0ca"

  bottle do
    cellar :any
    revision 3
    sha1 "e172450c5686c7f7e13237c927cb49cce4c0ac0c" => :yosemite
    sha1 "bbf17c08138fb53a4512732a2dab4f5c8dbec364" => :mavericks
    sha1 "c749e65dee61cd23b7e757a1308761d8396689e4" => :mountain_lion
    sha1 "d709c921f42e1f299b5bf09314eb73ab0dfa716d" => :lion
  end

  keg_only :provided_until_xcode43

  option :universal

  # apply upstream patch to respect '--program-prefix'
  # http://git.savannah.gnu.org/cgit/libtool.git/commit/?id=c77eea5f6c0592423d925131489cc7772e34cf0b
  # fix parallel build
  # http://git.savannah.gnu.org/cgit/libtool.git/commit/?id=5627a7f498e07a40b970c3a5ab5e74a5053e956f
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index d49abac..6840d3f 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -2290,7 +2290,7 @@ $(libtool_1): $(ltmain_sh)
 $(libtoolize_1): $(libtoolize_in)
 	$(AM_V_GEN)$(update_mans) libtoolize
 
-install-data-local: $(lt_Makefile_in)
+install-data-local: $(lt_Makefile_in) install-scripts-local
 	@$(NORMAL_INSTALL)
 	-rm -rf '$(DESTDIR)$(pkgdatadir)'/*
 	@list='$(pkgmacro_files)'; for p in $$list; do \
@@ -2318,8 +2318,15 @@ install-data-local: $(lt_Makefile_in)
 	  echo " $(INSTALL_DATA) '$(ltdldir)/$$p' '$(DESTDIR)$(pkgdatadir)/$$p'"; \
 	  $(INSTALL_DATA) "$(ltdldir)/$$p" "$(DESTDIR)$(pkgdatadir)/$$p"; \
 	done
-	$(SCRIPT_ENV) '$(inline_source)' libtoolize > '$(DESTDIR)$(bindir)/libtoolize';
-	-chmod a+x '$(DESTDIR)$(pkgdatadir)/configure' '$(DESTDIR)$(bindir)/libtoolize'
+	chmod a+x '$(DESTDIR)$(pkgdatadir)/configure'
+
+install-scripts-local: $(lt_Makefile_in)
+	@p=`echo libtoolize |sed -e '$(transform)'`; \
+	echo " $(SCRIPT_ENV) '$(inline_source)' libtoolize > '$(DESTDIR)$(bindir)/$$p'"; \
+	d=`echo "$(DESTDIR)$(bindir)/$$p" |$(SED) 's|[^/]*$$||'`; \
+	test -d "$$d" || $(mkinstalldirs) "$$d"; \
+	$(SCRIPT_ENV) '$(inline_source)' libtoolize > "$(DESTDIR)$(bindir)/$$p"; \
+	chmod a+x "$(DESTDIR)$(bindir)/$$p"
 $(changelog): FORCE
 	$(AM_V_GEN)if test -d '$(srcdir)/.git'; then \
 	  $(gitlog_to_changelog) --amend=$(git_log_fix) \
@@ -2366,8 +2373,9 @@ uninstall-hook:
 	  echo " rm -f '$(DESTDIR)$(aclocaldir)/$$f'"; \
 	  rm -f "$(DESTDIR)$(aclocaldir)/$$f"; \
 	done
-	@echo " rm -f '$(DESTDIR)$(bindir)/libtoolize'"; \
-	rm -f '$(DESTDIR)$(bindir)/libtoolize'
+	@p=`echo libtoolize |sed -e '$(transform)'`; \
+	echo " rm -f '$(DESTDIR)$(bindir)/$$p'"; \
+	rm -f "$(DESTDIR)$(bindir)/$$p"
 
 $(testsuite): $(package_m4) $(TESTSUITE_AT) Makefile.am
 	$(AM_V_GEN)$(AUTOTEST) -I '$(srcdir)' -I '$(srcdir)/tests' $(TESTSUITE_AT) -o '$@'
