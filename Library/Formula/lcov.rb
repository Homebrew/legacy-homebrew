require 'formula'

class Lcov < Formula
  url 'http://downloads.sourceforge.net/ltp/lcov-1.9.tar.gz'
  homepage 'http://ltp.sourceforge.net/coverage/lcov.php'
  md5 '8b88cfc0200a8c176b879ac115a31379'

  def install
    %w(bin/gendesc bin/genhtml bin/geninfo bin/genpng bin/lcov).each do |file|
      inreplace file, '/etc/lcovrc', "#{prefix}/etc/lcovrc"
    end
    system "make PREFIX=#{prefix} install"
  end

  def patches
    DATA
  end
end

__END__
--- lcov-1.8/bin/install.sh~	2010-01-29 19:14:46.000000000 +0900
+++ lcov-1.8/bin/install.sh	2010-04-16 21:40:57.000000000 +0900
@@ -34,7 +34,8 @@
   local TARGET=$2
   local PARAMS=$3
 
-  install -p -D $PARAMS $SOURCE $TARGET
+  mkdir -p `dirname $TARGET`
+  install -p $PARAMS $SOURCE $TARGET
 }
 
 
--- lcov-1.8/Makefile~	2010-01-29 19:14:46.000000000 +0900
+++ lcov-1.8/Makefile	2010-04-16 21:42:26.000000000 +0900
@@ -15,8 +15,8 @@
 RELEASE := 1
 
 CFG_DIR := $(PREFIX)/etc
-BIN_DIR := $(PREFIX)/usr/bin
-MAN_DIR := $(PREFIX)/usr/share/man
+BIN_DIR := $(PREFIX)/bin
+MAN_DIR := $(PREFIX)/share/man
 TMP_DIR := /tmp/lcov-tmp.$(shell echo $$$$)
 FILES   := $(wildcard bin/*) $(wildcard man/*) README CHANGES Makefile \
 	   $(wildcard rpm/*) lcovrc
