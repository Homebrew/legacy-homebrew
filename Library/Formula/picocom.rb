require 'formula'

class Picocom < Formula
  url 'http://picocom.googlecode.com/files/picocom-1.6.tar.gz'
  homepage 'http://code.google.com/p/picocom/'
  md5 '426c3d30b82cbc80b0dafdccd6020c6c'

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
diff --git a/Makefile b/Makefile
index 09846aa..fba128e 100644
--- a/Makefile
+++ b/Makefile
@@ -2,8 +2,7 @@
 VERSION=1.6

 # CC = gcc
-CPPFLAGS=-DVERSION_STR=\"$(VERSION)\" -DUUCP_LOCK_DIR=\"/var/lock\" \
-         -DHIGH_BAUD
+CPPFLAGS=-DVERSION_STR=\"$(VERSION)\" -DUUCP_LOCK_DIR=\"/var/lock\"
 CFLAGS = -Wall -g

 # LD = gcc
