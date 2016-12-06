require 'formula'

class Dpkg <Formula
  url 'http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.15.8.10.tar.bz2'
  homepage 'http://en.wikipedia.org/wiki/Dpkg'
  md5 'bce745c7083ace01da1df6cdcad35f9a'

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
			  "--without-start-stop-daemon",
			"PERL_LIBDIR=/Library/Perl/5.10.0/ "

    system "make install"
  end
end
__END__
diff --git a/configure b/configure
index a4e8516..de7f226 100755
--- a/configure
+++ b/configure
@@ -8171,9 +8171,9 @@ else
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
