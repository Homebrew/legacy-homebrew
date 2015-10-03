class Picocom < Formula
  desc "Minimal dump-terminal emulation program"
  homepage "https://code.google.com/p/picocom/"
  url "https://picocom.googlecode.com/files/picocom-1.7.tar.gz"
  sha256 "d0f31c8f7a215a76922d30c81a52b9a2348c89e02a84935517002b3bc2c1129e"

  patch :DATA # HIGH_BAUD is not defined

  def install
    system "make"
    bin.install "picocom"
    man8.install "picocom.8"
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
