require 'formula'

class Nginx < Formula
  url 'http://nginx.org/download/nginx-0.7.67.tar.gz'
  head 'http://nginx.org/download/nginx-0.8.42.tar.gz'
  homepage 'http://nginx.org/'

  if ARGV.include? '--HEAD'
    @md5='2818e8b03512b239f1238d702703bcf3'
  else
    @md5='b6e175f969d03a4d3c5643aaabc6a5ff'
  end

  skip_clean 'logs'

  def patches
    # Changes default port to 8080
    DATA
  end

  def options
    [
      ['--with-passenger', "Compile with support for Phusion Passenger module"]
    ]
  end

  def passenger_config_args
      passenger_root = `passenger-config --root`.chomp

      if File.directory?(passenger_root)
        return "--add-module=#{passenger_root}/ext/nginx"
      end

      puts "Unable to install nginx with passenger support. The passenger"
      puts "gem must be installed and passenger-config must be in your path"
      puts "in order to continue."
      exit
  end

  def install
    args = ["--prefix=#{prefix}", "--with-http_ssl_module"]
    args << passenger_config_args if ARGV.include? '--with-passenger'

    system "./configure", *args
    system "make install"
  end

  def caveats
    <<-CAVEATS
In the interest of allowing you to run `nginx` without `sudo`, the default
port is set to localhost:8080.

If you want to host pages on your local machine to the public, you should
change that to localhost:80, and run `sudo nginx`. You'll need to turn off
any other web servers running port 80, of course.
    CAVEATS
  end
end

__END__
--- a/conf/nginx.conf
+++ b/conf/nginx.conf
@@ -33,7 +33,7 @@
     #gzip  on;

     server {
-        listen       80;
+        listen       8080;
         server_name  localhost;

         #charset koi8-r;
