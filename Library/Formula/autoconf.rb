require 'formula'

class Autoconf < Formula
  homepage 'http://www.gnu.org/software/autoconf'
  url 'http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz'
  sha1 '562471cbcb0dd0fa42a76665acf0dbb68479b78a'

  if MacOS::Xcode.provides_autotools? or File.file? "/usr/bin/autoconf"
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
    system "#{bin}/autoconf", "--version"
  end
end


__END__
--- a/bin/autoreconf.in	2012-04-24 15:00:28.000000000 -0700
+++ b/bin/autoreconf.in	2012-04-24 21:51:41.000000000 -0700
@@ -111,7 +111,7 @@
 my $autom4te   = $ENV{'AUTOM4TE'}   || '@bindir@/@autom4te-name@';
 my $automake   = $ENV{'AUTOMAKE'}   || 'automake';
 my $aclocal    = $ENV{'ACLOCAL'}    || 'aclocal';
-my $libtoolize = $ENV{'LIBTOOLIZE'} || 'libtoolize';
+my $libtoolize = $ENV{'LIBTOOLIZE'} || 'glibtoolize';
 my $autopoint  = $ENV{'AUTOPOINT'}  || 'autopoint';
 my $make       = $ENV{'MAKE'}       || 'make';
 
