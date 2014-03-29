require 'formula'

class Dpkg < Formula
  homepage 'https://wiki.debian.org/Teams/Dpkg'
  url 'http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.17.6.tar.xz'
  sha1 '93d1d55fa82a9bcebfa4f7fdc50f1cb7d1d734e1'

  depends_on 'pkg-config' => :build
  depends_on 'gnu-tar'

  # Fixes the PERL_LIBDIR.
  # Uses Homebrew-install gnu-tar instead of bsd tar.
  patch :DATA

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
+#define TAR		"gtar"
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

diff --git a/scripts/Dpkg/Checksums.pm b/scripts/Dpkg/Checksums.pm
index 4a64fd1..bb19f59 100644
--- a/scripts/Dpkg/Checksums.pm
+++ b/scripts/Dpkg/Checksums.pm
@@ -50,15 +50,15 @@ about supported checksums.
 
 my $CHECKSUMS = {
     md5 => {
-	program => [ 'md5sum' ],
+	program => [ 'md5', '-q' ],
 	regex => qr/[0-9a-f]{32}/,
     },
     sha1 => {
-	program => [ 'sha1sum' ],
+	program => [ 'shasum', '-a', '1' ],
 	regex => qr/[0-9a-f]{40}/,
     },
     sha256 => {
-	program => [ 'sha256sum' ],
+	program => [ 'shasum', '-a', '256' ],
 	regex => qr/[0-9a-f]{64}/,
     },
 };
diff --git a/scripts/Dpkg/Source/Archive.pm b/scripts/Dpkg/Source/Archive.pm
index de30bf4..c97d421 100644
--- a/scripts/Dpkg/Source/Archive.pm
+++ b/scripts/Dpkg/Source/Archive.pm
@@ -47,7 +47,7 @@ sub create {
     $spawn_opts{from_pipe} = \*$self->{tar_input};
     # Call tar creation process
     $spawn_opts{delete_env} = [ 'TAR_OPTIONS' ];
-    $spawn_opts{exec} = [ 'tar', '--null', '-T', '-', '--numeric-owner',
+    $spawn_opts{exec} = [ 'gtar', '--null', '-T', '-', '--numeric-owner',
                             '--owner', '0', '--group', '0',
                             @{$opts{options}}, '-cf', '-' ];
     *$self->{pid} = spawn(%spawn_opts);
@@ -123,7 +123,7 @@ sub extract {

     # Call tar extraction process
     $spawn_opts{delete_env} = [ 'TAR_OPTIONS' ];
-    $spawn_opts{exec} = [ 'tar', '--no-same-owner', '--no-same-permissions',
+    $spawn_opts{exec} = [ 'gtar', '--no-same-owner', '--no-same-permissions',
                             @{$opts{options}}, '-xf', '-' ];
     spawn(%spawn_opts);
     $self->close();
