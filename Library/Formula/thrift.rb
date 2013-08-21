require 'formula'

class Thrift < Formula
  homepage 'http://thrift.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.9.0/thrift-0.9.0.tar.gz'
  sha1 'fefcf4d729bf80da419407dfa028740aa95fa2e3'

  head 'http://svn.apache.org/repos/asf/thrift/trunk'

  # Prefer Homebrew stuff ie. local php
  env :userpaths

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  depends_on 'boost'
  depends_on :python => :optional
  depends_on "php53" => [:optional, 'with-php'] if Formula.factory("php53").installed?
  depends_on "php54" => [:optional, 'with-php'] if Formula.factory("php54").installed?
  depends_on "php55" => [:optional, 'with-php'] if Formula.factory("php55").installed?

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

    # So PHP bindings don't install to /usr!
    if build.include? "with-php"
        # ENV["PHP_PREFIX"] = %x(php-config --prefix).chomp + "/lib/php"
	# Rather than installing to a version specific internal php dir as above, use /usr/local/lib/Thrift
        ENV["PHP_PREFIX"] = "#{HOMEBREW_PREFIX}/lib"
        ENV["PHP_CONFIG_PREFIX"] = "#{HOMEBREW_PREFIX}/etc/php/5.3/conf.d" if Formula.factory("php53").installed?
        ENV["PHP_CONFIG_PREFIX"] = "#{HOMEBREW_PREFIX}/etc/php/5.4/conf.d" if Formula.factory("php54").installed?
        ENV["PHP_CONFIG_PREFIX"] = "#{HOMEBREW_PREFIX}/etc/php/5.5/conf.d" if Formula.factory("php55").installed?
    end

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
