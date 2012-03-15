require 'formula'

class Autoconf < Formula
  homepage 'http://www.gnu.org/software/autoconf'
  url 'http://ftpmirror.gnu.org/autoconf/autoconf-2.68.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.68.tar.gz'
  md5 'c3b5247592ce694f7097873aa07d66fe'

  if MacOS.xcode_version.to_f < 4.3 or File.file? "/usr/bin/autoconf"
    keg_only "Xcode (up to and including 4.2) provides (a rather old) Autoconf."
  end

  def patches
    # force autoreconf to look for and use our glibtoolize
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/autoconf --version"
  end
end


__END__
diff --git a/bin/autoreconf.in b/bin/autoreconf.in
index 192c8fa..70a1d72 100644
--- a/bin/autoreconf.in
+++ b/bin/autoreconf.in
@@ -112,7 +112,7 @@ my $autoheader = $ENV{'AUTOHEADER'} || '@bindir@/@autoheader-name@';
 my $autom4te   = $ENV{'AUTOM4TE'}   || '@bindir@/@autom4te-name@';
 my $automake   = $ENV{'AUTOMAKE'}   || 'automake';
 my $aclocal    = $ENV{'ACLOCAL'}    || 'aclocal';
-my $libtoolize = $ENV{'LIBTOOLIZE'} || 'libtoolize';
+my $libtoolize = $ENV{'LIBTOOLIZE'} || 'glibtoolize';
 my $autopoint  = $ENV{'AUTOPOINT'}  || 'autopoint';
 my $make       = $ENV{'MAKE'}       || 'make';
 
