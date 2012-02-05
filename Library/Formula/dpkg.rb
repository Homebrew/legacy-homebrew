require 'formula'

class Dpkg < Formula
  url 'http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.15.8.12.tar.bz2'
  homepage 'http://en.wikipedia.org/wiki/Dpkg'
  md5 '0cd6f20a574d0df31298e70fc3b26173'

  depends_on 'pkg-config' => :build

  #Fixes the PERL_LIBDIR
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
