require 'formula'

class Since < Formula
  url 'http://welz.org.za/projects/since/since-1.1.tar.gz'
  homepage 'http://welz.org.za/projects/since'
  md5 '7a6cfe573d0d2ec7b6f53fe9432a486b'

  def patches; DATA; end

  def install
    system "make install"
  end
end

__END__
diff -Naur old/Makefile new/Makefile
--- old/Makefile	2011-07-30 18:36:00.000000000 -0700
+++ new/Makefile	2011-07-30 18:36:36.000000000 -0700
@@ -12,7 +12,7 @@
 
 CC = gcc
 RM = rm -f
-INSTALL = install -D
+INSTALL = install
 
 $(NAME): $(NAME).c
 	$(CC) $(CFLAGS) -o $@ $^
