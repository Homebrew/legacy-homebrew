require 'formula'

class Cabocha < Formula
  homepage 'http://code.google.com/p/cabocha/'
  url 'http://cabocha.googlecode.com/files/cabocha-0.66.tar.bz2'
  sha1 '33172b7973239a53d98eabbd309f70d88e36c94c'

  depends_on 'crf++'
  depends_on 'mecab'

  # Fix finding unistd
  def patches; DATA; end

  def install
    ENV["LIBS"] = '-liconv'

    inreplace 'Makefile.in' do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
      s.change_make_var! 'CXXFLAGS', ENV.cflags
    end

    system "./configure", "--with-charset=utf8",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/utils.cpp b/src/utils.cpp
index b0cee48..4ab074a 100644
--- a/src/utils.cpp
+++ b/src/utils.cpp
@@ -3,9 +3,7 @@
 //  $Id: utils.cpp 50 2009-05-03 08:25:36Z taku-ku $;
 //
 //  Copyright(C) 2001-2008 Taku Kudo <taku@chasen.org>
-#ifdef HAVE_UNISTD_H
 #include <unistd.h>
-#endif
 
 #include <iostream>
 #include <fstream>
