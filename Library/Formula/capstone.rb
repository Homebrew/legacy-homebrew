require 'formula'

class Capstone < Formula
  homepage 'http://capstone-engine.org'
  url 'http://capstone-engine.org/download/2.1/capstone-2.1.1.tgz'
  sha1 'f4b114aba2626832f1c217191faaa748245d76a8'

  def patches
    # Fix Makefile. Upstream fix is at :
    # https://github.com/aquynh/capstone/commit/22b867e
    DATA
  end

  def install
    # Fixed upstream in next version:
    # https://github.com/aquynh/capstone/commit/dc0d04
    inreplace 'Makefile', 'lib64', 'lib'
    system "./make.sh"
    ENV["PREFIX"] = prefix
    system "./make.sh", "install"
  end
end

__END__
--- a/Makefile.org	2014-03-11 11:51:47.000000000 +0800
+++ a/Makefile	2014-03-11 11:56:07.000000000 +0800
@@ -149,13 +149,6 @@
 # remove string check because OS X kernel complains about missing symbols
 CFLAGS += -D_FORTIFY_SOURCE=0
 endif
-# By default, suppose that Brew is installed & use Brew path for pkgconfig file
-PKGCFCGDIR = /usr/local/lib/pkgconfig
-# is Macport installed instead?
-ifneq (,$(wildcard /opt/local/bin/port))
-# then correct the path for pkgconfig file
-PKGCFCGDIR = /opt/local/lib/pkgconfig
-endif
 else
 # Cygwin?
 IS_CYGWIN := $(shell $(CC) -dumpmachine | grep -i cygwin | wc -l)
