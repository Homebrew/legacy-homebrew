require 'formula'

class Rgit < Formula
  url 'http://search.cpan.org/CPAN/authors/id/V/VP/VPIT/rgit-0.08.tar.gz'
  homepage 'http://search.cpan.org/dist/rgit/'
  md5 'af78e3876e28bf9f6951ca7df1db0b3c'

  def patches
    # patch to include the Cellar perl lib path
    DATA
  end

  def install
    system "perl Makefile.PL PREFIX=#{prefix} INSTALL_BASE="
    system "make install"
  end
end

__END__
diff --git a/bin/rgit b/bin/rgit
index 61f9456..56fcebb 100755
--- a/bin/rgit
+++ b/bin/rgit
@@ -3,6 +3,13 @@
 use strict;
 use warnings;
 
+use File::Basename qw(dirname);
+use Cwd qw(abs_path realpath);
+
+BEGIN {
+    push @INC, realpath( dirname( abs_path($0) ) . '/../lib/perl5/site_perl' );
+}
+
 use Carp   qw/croak/;
 use Config qw/%Config/;
 use Cwd    qw/cwd/;

