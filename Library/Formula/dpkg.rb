require 'formula'

class Dpkg < Formula
  homepage 'http://en.wikipedia.org/wiki/Dpkg'
  url 'http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.15.8.13.tar.bz2'
  sha1 'd0b9386742f966345a23c3daa0391b37fa837a3f'

  depends_on 'pkg-config' => :build
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
                          "--disable-compiler-warnings",
                          "--disable-linker-optimisations",
                          "--disable-compiler-optimisations",
                          "--without-start-stop-daemon"
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
