require 'formula'

class Thrift < Formula
  homepage 'http://thrift.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.9.0/thrift-0.9.0.tar.gz'
  sha1 'fefcf4d729bf80da419407dfa028740aa95fa2e3'

  head do
    url 'https://git-wip-us.apache.org/repos/asf/thrift.git', :branch => "master"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  depends_on 'boost'
  depends_on :python => :optional

  # Includes are fixed in the upstream. Please remove this patch in the next version > 0.9.0
  def patches
    DATA
  end

  def install
    system "./bootstrap.sh" if build.head?

    exclusions = ["--without-ruby"]

    exclusions << "--without-python" unless build.with? "python"
    exclusions << "--without-haskell" unless build.include? "with-haskell"
    exclusions << "--without-java" unless build.include? "with-java"
    exclusions << "--without-perl" unless build.include? "with-perl"
    exclusions << "--without-php" unless build.include? "with-php"
    exclusions << "--without-erlang" unless build.include? "with-erlang"

    ENV["PY_PREFIX"] = prefix  # So python bindins don't install to /usr!

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *exclusions
    ENV.j1
    system "make"
    system "make install"
  end

  def caveats
    s = <<-EOS.undent
    To install Ruby bindings:
      gem install thrift

    To install PHP bindings:
      export PHP_PREFIX=/path/to/homebrew/thrift/0.9.0/php
      export PHP_CONFIG_PREFIX=/path/to/homebrew/thrift/0.9.0/php_extensions
      brew install thrift --with-php

    EOS
    s += python.standard_caveats if python
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
