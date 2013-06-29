require 'formula'

class Picocom < Formula
  homepage 'http://code.google.com/p/picocom/'
  url 'http://picocom.googlecode.com/files/picocom-1.7.tar.gz'
  sha1 'bde6e36af71db845913f9d61f28dee1b485218fa'

  def patches
    # HIGH_BAUD is not defined
    DATA
  end


  def install
    system "make"
    bin.install "picocom"
  end
end

__END__
--- a/Makefile	2012-02-20 21:42:24.000000000 -0800
+++ b/Makefile	2012-10-12 23:26:08.000000000 -0700
@@ -5,8 +5,7 @@

 # CC = gcc
 CPPFLAGS=-DVERSION_STR=\"$(VERSION)\" \
-         -DUUCP_LOCK_DIR=\"$(UUCP_LOCK_DIR)\" \
-         -DHIGH_BAUD
+         -DUUCP_LOCK_DIR=\"$(UUCP_LOCK_DIR)\"
 CFLAGS = -Wall -g

 # LD = gcc
