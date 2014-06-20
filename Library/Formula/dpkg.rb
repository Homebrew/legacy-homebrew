require 'formula'

class Dpkg < Formula
  homepage 'https://wiki.debian.org/Teams/Dpkg'
  url 'http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.17.10.tar.xz'
  sha1 '2d88ef04db662d046fadb005bb31667fc0ba64de'

  depends_on 'pkg-config' => :build
  depends_on 'gnu-tar'

  # Fixes the PERL_LIBDIR.
  patch :DATA

  def install
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system 'tar', which will fail because it lacks certain switches.
    ENV["TAR"] = Formula["gnu-tar"].opt_bin/"gtar"
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
index 668eefd..2f54912 100755
--- a/configure
+++ b/configure
@@ -8875,9 +8875,7 @@ if test "$PERL" = "no" || test ! -x "$PERL"; then
 fi
 # Let the user override the variable.
 if test -z "$PERL_LIBDIR"; then
-PERL_LIBDIR=$($PERL -MConfig -e 'my $r = $Config{vendorlibexp};
-                                 $r =~ s/$Config{vendorprefixexp}/\$(prefix)/;
-                                 print $r')
+PERL_LIBDIR="$prefix/perl"
 fi
 
 
diff --git a/scripts/Dpkg/Checksums.pm b/scripts/Dpkg/Checksums.pm
index 07a917c..86d267a 100644
--- a/scripts/Dpkg/Checksums.pm
+++ b/scripts/Dpkg/Checksums.pm
@@ -51,15 +51,15 @@ about supported checksums.
 
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
index 6257702..af6101d 100644
--- a/scripts/Dpkg/Source/Archive.pm
+++ b/scripts/Dpkg/Source/Archive.pm
@@ -48,7 +48,7 @@ sub create {
     $spawn_opts{from_pipe} = \*$self->{tar_input};
     # Call tar creation process
     $spawn_opts{delete_env} = [ 'TAR_OPTIONS' ];
-    $spawn_opts{exec} = [ 'tar', '--null', '-T', '-', '--numeric-owner',
+    $spawn_opts{exec} = [ 'gtar', '--null', '-T', '-', '--numeric-owner',
                             '--owner', '0', '--group', '0',
                             @{$opts{options}}, '-cf', '-' ];
     *$self->{pid} = spawn(%spawn_opts);
@@ -125,7 +125,7 @@ sub extract {
 
     # Call tar extraction process
     $spawn_opts{delete_env} = [ 'TAR_OPTIONS' ];
-    $spawn_opts{exec} = [ 'tar', '--no-same-owner', '--no-same-permissions',
+    $spawn_opts{exec} = [ 'gtar', '--no-same-owner', '--no-same-permissions',
                             @{$opts{options}}, '-xf', '-' ];
     spawn(%spawn_opts);
     $self->close();
diff --git a/scripts/Makefile.am b/scripts/Makefile.am
index 45cb3d4..bd55234 100644
--- a/scripts/Makefile.am
+++ b/scripts/Makefile.am
@@ -119,7 +119,7 @@ nobase_dist_perllib_DATA = \
 man3_MANS =
 
 do_perl_subst = $(AM_V_GEN) \
-		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL):" \
+		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL) -I$(PERL_LIBDIR):" \
 		    -e "s:\$$CONFDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$CONFDIR='$(pkgconfdir)':" \
 		    -e "s:\$$ADMINDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$ADMINDIR='$(admindir)':" \
 		    -e "s:\$$LIBDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$LIBDIR='$(pkglibdir)':" \
diff --git a/scripts/Makefile.in b/scripts/Makefile.in
index 098c202..4b089d7 100644
--- a/scripts/Makefile.in
+++ b/scripts/Makefile.in
@@ -490,7 +490,7 @@ nobase_dist_perllib_DATA = \
 # Keep it even if empty to have man3dir correctly set
 man3_MANS = 
 do_perl_subst = $(AM_V_GEN) \
-		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL):" \
+		sed -e "s:^\#![[:space:]]*/usr/bin/perl:\#!$(PERL) -I$(PERL_LIBDIR):" \
 		    -e "s:\$$CONFDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$CONFDIR='$(pkgconfdir)':" \
 		    -e "s:\$$ADMINDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$ADMINDIR='$(admindir)':" \
 		    -e "s:\$$LIBDIR[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]:\$$LIBDIR='$(pkglibdir)':" \
