require 'formula'

class Perl < Formula
  url 'http://www.cpan.org/src/5.0/perl-5.14.1.tar.gz'
  homepage 'http://www.perl.org/'
  md5 '0b74cffa3a10aee08442f950aecbaeec'

  def patches
      # Fix compilation on Lion per http://perl5.git.perl.org/perl.git/commit/60a655a1ee05c577268377c1135ffabc34dbff43
      { :p0 => DATA }
  end

  def install
    system("rm -f config.sh Policy.sh");
    system "./Configure", "-des", "-Dprefix=#{prefix}",
      # HACK: Force mandirs to use brew-friendly paths
      "-Dman1dir=#{man1}", "-Dman3dir=#{man3}",
      "-Dusethreads", "-Duseshrplib", "-Duselargefiles"
    system "make"
    system "make test"
    system "make install"
  end
end

__END__
--- hints/darwin.sh	2011-08-07 21:05:35.000000000 +0100
+++ hints/darwin.sh	2011-08-07 21:15:18.000000000 +0100
@@ -73,8 +73,10 @@
 # Since we can build fat, the archname doesn't need the processor type
 archname='darwin';
 
-# nm works.
-usenm='true';
+# nm isn't known to work after Snow Leopard and XCode 4; testing with OS X 10.5
+# and Xcode 3 shows a working nm, but pretending it doesn't work produces no
+# problems.
+usenm='false';
 
 case "$optimize" in
 '')
