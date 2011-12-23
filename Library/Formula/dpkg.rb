require 'formula'

class Dpkg < Formula
  url 'http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.15.8.11.tar.bz2'
  homepage 'http://en.wikipedia.org/wiki/Dpkg'
  md5 '58a1a3ab86ab3220e469cb75f6fb6d7c'

  depends_on 'gnu-tar'

  def patches
    #Fixes the PERL_LIBDIR
    DATA
  end
  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-compiler-warnings",
                          "--disable-linker-optimisations",
                          "--disable-compiler-optimisations",
                          "--without-start-stop-daemon"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index a4e8516..de7f226 100755
--- a/configure
+++ b/configure
@@ -8180,9 +8180,9 @@ else
 $as_echo "no" >&6; }
 fi
 
-PERL_LIBDIR=$($PERL -MConfig -e 'my $r = $Config{vendorlibexp};
-                                 $r =~ s/$Config{vendorprefixexp}/\$(prefix)/;
-                                 print $r')
+PERL_LIBDIR=$($PERL -MConfig -e 'my $r = $Config{sitelib}; 
+                                 $r =~ s/$Config{sitelib}/\$(prefix)/;
+                                 print $r')
 
 for ac_prog in pod2man
 do
diff --git a/lib/dpkg/dpkg.h b/lib/dpkg/dpkg.h
index ba6066c..89a66ba 100644
--- a/lib/dpkg/dpkg.h
+++ b/lib/dpkg/dpkg.h
@@ -97,7 +97,7 @@
 #define DPKG  	"dpkg"
 #define DEBSIGVERIFY	"/usr/bin/debsig-verify"
 
-#define TAR		"tar"
+#define TAR		"gnutar"
 #define RM		"rm"
 #define FIND		"find"
 #define DIFF		"diff"
