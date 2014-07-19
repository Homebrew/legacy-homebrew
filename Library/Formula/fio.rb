require 'formula'

class Fio < Formula
  homepage 'http://freecode.com/projects/fio'
  url 'http://brick.kernel.dk/snaps/fio-2.1.11.tar.bz2'
  sha1 '3b672f19ef37d0f4d733dc78820a5e4a735b9a7f'
  patch :DATA

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 65e95be..ef787ac 100644
--- a/Makefile
+++ b/Makefile
@@ -200,16 +200,10 @@ ifeq ($(CONFIG_TARGET_OS), SunOS)
 else
        INSTALL = install
 endif
-prefix = /usr/local
 bindir = $(prefix)/bin
 
-ifeq ($(CONFIG_TARGET_OS), Darwin)
-mandir = /usr/share/man
-sharedir = /usr/share/fio
-else
 mandir = $(prefix)/man
 sharedir = $(prefix)/share/fio
-endif
 
 all: $(PROGS) $(SCRIPTS) FORCE
 

