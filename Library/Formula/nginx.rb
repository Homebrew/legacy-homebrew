require 'brewkit'

class Nginx < Formula
  @url='http://sysoev.ru/nginx/nginx-0.7.62.tar.gz'
  @homepage='http://nginx.net/'
  @md5='ab22f1b7f098a90d803a3abb94d23f7e'

  depends_on 'pcre'

  def patches
    DATA
  end

  def options
    [
      ['--with-passenger', "Compile with support for Phusion Passenger module"]
    ]
  end
    
  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--with-http_ssl_module"
    ]
    
    if ARGV.include? '--with-passenger'
      passenger_root = `passenger-config --root`.chomp
      
      if File.directory?(passenger_root)
        configure_args << "--add-module=#{passenger_root}/ext/nginx"
      else
        puts "Unable to install nginx with passenger support. The passenger"
        puts "gem must be installed and passenger-config must be in your path"
        puts "in order to continue."
        exit
      end
    end
    
    system "./configure", *configure_args
    system "make install"
  end 
end

__END__
--- a/auto/lib/pcre/conf
+++ b/auto/lib/pcre/conf
@@ -155,6 +155,22 @@ else
             . auto/feature
         fi
 
+        if [ $ngx_found = no ]; then
+
+            # Homebrew
+           HOMEBREW_PREFIX=${NGX_PREFIX%Cellar*}
+            ngx_feature="PCRE library in ${HOMEBREW_PREFIX}"
+            ngx_feature_path="${HOMEBREW_PREFIX}/include"
+
+            if [ $NGX_RPATH = YES ]; then
+                ngx_feature_libs="-R#{HOMEBREW_PREFIX}/lib -L#{HOMEBREW_PREFIX}/lib -lpcre"
+            else
+                ngx_feature_libs="-L#{HOMEBREW_PREFIX}/lib -lpcre"
+            fi
+
+            . auto/feature
+        fi
+
         if [ $ngx_found = yes ]; then
             CORE_DEPS="$CORE_DEPS $REGEX_DEPS"
             CORE_SRCS="$CORE_SRCS $REGEX_SRCS"

