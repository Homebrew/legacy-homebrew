require 'formula'

class Getxbook < Formula
  homepage 'http://njw.me.uk/software/getxbook/'
  url 'http://njw.me.uk/software/getxbook/getxbook-0.8.tar.bz2'
  sha1 'd08d082cd6481302c102fcd7c373258737b2bd3d'

  def patches
    # Remove -Werror, fixes compilation with clang.  Not an issue for llvm-gcc.
    #    error: too many arguments in call to 'getpagelist'
    # Reported upstream via email to bug-getxbook@njw.me.uk (no tracker).
    # This issue still exists in HEAD as of 19 APR 2012.
    DATA
  end

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "install"
  end
end

__END__
--- a/config.mk	2012-02-14 14:09:56.000000000 -0800
+++ b/config.mk	2012-04-19 23:24:22.000000000 -0700
@@ -6,7 +6,7 @@
 PREFIX = /usr/local
 MANPREFIX = $(PREFIX)/share/man
 
-CFLAGS = -std=c99 -pedantic -Wall -Wextra -Werror -g -D_POSIX_C_SOURCE=200112L \
+CFLAGS = -std=c99 -pedantic -Wall -Wextra -g -D_POSIX_C_SOURCE=200112L \
          -DVERSION=\"$(VERSION)\"
 
 W32TCLKIT = tclkit-8.5.9-win32.upx.exe
