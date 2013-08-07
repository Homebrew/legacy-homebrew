require 'formula'

class Dpkg < Formula
  homepage 'https://wiki.debian.org/Teams/Dpkg'
  url 'http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.17.1.tar.xz'
  sha1 'c94b33573806cf9662c5a6f2bbae64900113a538'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gnu-tar'

  fails_with :clang do
    cause 'cstdlib:142:3: error: declaration conflicts with target of using declaration already in scope'
  end

  # Fixes the PERL_LIBDIR.
  # Uses Homebrew-install gnu-tar instead of bsd tar.
  def patches; DATA; end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-dselect",
                          "--disable-linker-optimisations",
                          "--disable-start-stop-daemon",
                          "--disable-update-alternatives"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This installation of dpkg is not configured to install software, so
    commands such as `dpkg -i`, `dpkg --configure` will fail.
    EOS
  end
end

__END__
diff --git a/configure b/configure
index 5d91530..dd2ca11 100755
--- a/configure
+++ b/configure
@@ -8388,9 +8388,7 @@ if test "$PERL" = "no" || test ! -x "$PERL"; then
 fi
 # Let the user override the variable.
 if test -z "$PERL_LIBDIR"; then
-PERL_LIBDIR=$($PERL -MConfig -e 'my $r = $Config{vendorlibexp};
-                                 $r =~ s/$Config{vendorprefixexp}/\$(prefix)/;
-                                 print $r')
+PERL_LIBDIR="$prefix/perl"
 fi
 
 
diff --git a/lib/dpkg/dpkg.h b/lib/dpkg/dpkg.h
index c0f633d..b692806 100644
--- a/lib/dpkg/dpkg.h
+++ b/lib/dpkg/dpkg.h
@@ -108,7 +108,7 @@ DPKG_BEGIN_DECLS
 #define DPKG		"dpkg"
 #define DEBSIGVERIFY	"/usr/bin/debsig-verify"
 
-#define TAR		"tar"
+#define TAR		"gnutar"
 #define RM		"rm"
 #define CAT		"cat"
 #define FIND		"find"
diff --git a/scripts/Makefile.am b/scripts/Makefile.am
index f83adff..d2b5043 100644
--- a/scripts/Makefile.am
+++ b/scripts/Makefile.am
@@ -117,7 +117,7 @@ nobase_dist_perllib_DATA = \
 man3_MANS =
 
 do_perl_subst = $(AM_V_GEN) \
-		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL):" \
+		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL) -I$(PERL_LIBDIR):" \
 		    -e "s:\$$CONFDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$CONFDIR='$(pkgconfdir)':" \
 		    -e "s:\$$ADMINDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$ADMINDIR='$(admindir)':" \
 		    -e "s:\$$LIBDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$LIBDIR='$(pkglibdir)':" \
diff --git a/scripts/Makefile.in b/scripts/Makefile.in
index 754488e..8b233fb 100644
--- a/scripts/Makefile.in
+++ b/scripts/Makefile.in
@@ -486,7 +486,7 @@ nobase_dist_perllib_DATA = \
 # Keep it even if empty to have man3dir correctly set
 man3_MANS = 
 do_perl_subst = $(AM_V_GEN) \
-		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL):" \
+		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL) -I$(PERL_LIBDIR):" \
 		    -e "s:\$$CONFDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$CONFDIR='$(pkgconfdir)':" \
 		    -e "s:\$$ADMINDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$ADMINDIR='$(admindir)':" \
 		    -e "s:\$$LIBDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$LIBDIR='$(pkglibdir)':" \
