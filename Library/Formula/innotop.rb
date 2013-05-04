require 'formula'

class Innotop < Formula
  homepage 'http://code.google.com/p/innotop/'
  url 'http://innotop.googlecode.com/files/innotop-1.9.0.tar.gz'
  sha1 '4f8cbf6d01a1723a5c450d66e192610c5b28c4d7'

  depends_on 'DBD::mysql' => :perl
  depends_on 'Term::ReadKey' => :perl

  # Use /usr/bin/env in shebang; present upstream
  def patches; DATA; end

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/innotop b/innotop
index 0606349..3fa033d 100755
--- a/innotop
+++ b/innotop
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # vim: tw=160:nowrap:expandtab:tabstop=3:shiftwidth=3:softtabstop=3
 
