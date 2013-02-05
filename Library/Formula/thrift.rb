require 'formula'

class Thrift < Formula
  homepage 'http://thrift.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.9.0/thrift-0.9.0.tar.gz'
  sha1 'fefcf4d729bf80da419407dfa028740aa95fa2e3'

  head 'http://svn.apache.org/repos/asf/thrift/trunk'

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  depends_on 'boost'

  # Includes are fixed in the upstream. Please remove this patch in the next version > 0.9.0
  def patches
    DATA
  end

  def install
    # No reason for this step is known. On Lion at least the pkg.m4 doesn't
    # even exist. Turns out that it isn't needed on Lion either. Possibly it
    # isn't needed anymore at all but I can't test that.
    cp "#{MacOS::X11.share}/aclocal/pkg.m4", "aclocal" if MacOS.version < :lion

    system "./bootstrap.sh" if build.head?

    exclusions = ["--without-python", "--without-ruby"]

    exclusions << "--without-haskell" unless build.include? "with-haskell"
    exclusions << "--without-java" unless build.include? "with-java"
    exclusions << "--without-perl" unless build.include? "with-perl"
    exclusions << "--without-php" unless build.include? "with-php"
    exclusions << "--without-erlang" unless build.include? "with-erlang"

    # Language bindings try to install outside of Homebrew's prefix, so
    # omit them here. For ruby you can install the gem, and for Python
    # you can use pip or easy_install.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *exclusions
    ENV.j1
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To install Python bindings:
      pip install thrift

    To install Ruby bindings:
      gem install thrift

    To install PHP bindings:
      export PHP_PREFIX=/path/to/homebrew/thrift/0.9.0/php
      export PHP_CONFIG_PREFIX=/path/to/homebrew/thrift/0.9.0/php_extensions
      brew install thrift --with-php
    EOS
  end
end
__END__
diff --git a/lib/cpp/src/thrift/transport/TSocket.h b/lib/cpp/src/thrift/transport/TSocket.h
index ff5e541..65e6aea 100644
--- a/lib/cpp/src/thrift/transport/TSocket.h
+++ b/lib/cpp/src/thrift/transport/TSocket.h
@@ -21,6 +21,8 @@
 #define _THRIFT_TRANSPORT_TSOCKET_H_ 1

 #include <string>
+#include <sys/socket.h>
+#include <arpa/inet.h>

 #include "TTransport.h"
 #include "TVirtualTransport.h"
