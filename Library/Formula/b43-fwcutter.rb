require "formula"

class B43Fwcutter < Formula
  homepage "http://wireless.kernel.org/en/users/Drivers/b43"
  url "http://bues.ch/b43/fwcutter/b43-fwcutter-018.tar.bz2"
  sha1 "e77ff733ec43d77761330e16480b7ffa16c7c5dd"

  # Use OSSwapInt16/32 instead of GNU byteswap.h.
  # This has been accepted upstream but has not yet been
  # officially released. See:
  # https://github.com/mbuesch/b43-tools/pull/1
  patch :DATA

  def install
    inreplace 'Makefile' do |m|
      # Don't try to chown root:root on generated files
      m.gsub! /install -o 0 -g 0/, 'install'
      m.gsub! /install -d -o 0 -g 0/, 'install -d'
      # Fix manpage installation directory
      m.gsub! "$(PREFIX)/man", man
    end
    # b43-fwcutter has no ./configure
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/b43-fwcutter", "--version"
  end
end

__END__
--- a/fwcutter.h
+++ b/fwcutter.h
@@ -22,2 +22,5 @@
 #define bswap_32bswap32
+#elif defined(__APPLE__)
+#define bswap_16	OSSwapInt16
+#define bswap_32	OSSwapInt32
 #endif
--- a/fwcutter.c
+++ b/fwcutter.c
@@ -42,2 +42,4 @@
 #include <sys/endian.h>
+#elif defined(__APPLE__)
+#include <libkern/OSByteOrder.h>
 #else
