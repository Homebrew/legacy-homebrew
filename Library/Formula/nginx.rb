require 'formula'

class Nginx < Formula
  homepage 'http://nginx.org/'
  url 'http://nginx.org/download/nginx-1.0.10.tar.gz'
  head 'http://nginx.org/download/nginx-1.1.11.tar.gz'

  if ARGV.build_head?
    md5 '1eeef6fbe8fb0ee6b2f15e145ffd9c7d'
  else
    md5 '930b297b00fa1018fb0a1dd3e6b7e17e'
  end

  depends_on 'pcre'

  skip_clean 'logs'

  # Changes default port to 8080
  # Tell configure to look for pcre in HOMEBREW_PREFIX
  def patches
    DATA
  end

  def options
    [
      ['--with-passenger', "Compile with support for Phusion Passenger module"],
      ['--with-webdav',    "Compile with support for WebDAV module"]
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
    args = ["--prefix=#{prefix}",
            "--with-http_ssl_module",
            "--with-pcre",
            "--conf-path=#{etc}/nginx/nginx.conf",
            "--pid-path=#{var}/run/nginx.pid",
            "--lock-path=#{var}/nginx/nginx.lock"]

    args << passenger_config_args if ARGV.include? '--with-passenger'
    args << "--with-http_dav_module" if ARGV.include? '--with-webdav'

    system "./configure", *args
    system "make"
    system "make install"
    man8.install "objs/nginx.8"

    (prefix+'org.nginx.nginx.plist').write startup_plist
    (prefix+'org.nginx.nginx.plist').chmod 0644
  end

  def caveats; <<-EOS.undent
    In the interest of allowing you to run `nginx` without `sudo`, the default
    port is set to localhost:8080.

    If you want to host pages on your local machine to the public, you should
    change that to localhost:80, and run `sudo nginx`. You'll need to turn off
    any other web servers running port 80, of course.

    You can start nginx automatically on login running as your user with:
      mkdir -p ~/Library/LaunchAgents
      cp #{prefix}/org.nginx.nginx.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.nginx.nginx.plist

    Though note that if running as your user, the launch agent will fail if you
    try to use a port below 1024 (such as http's default of 80.)
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.nginx.nginx</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{sbin}/nginx</string>
        <string>-g</string>
        <string>daemon off;</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end
end

__END__
--- a/auto/lib/pcre/conf
+++ b/auto/lib/pcre/conf
@@ -155,6 +155,21 @@ else
             . auto/feature
         fi

+        if [ $ngx_found = no ]; then
+
+            # Homebrew
+            ngx_feature="PCRE library in HOMEBREW_PREFIX"
+            ngx_feature_path="HOMEBREW_PREFIX/include"
+
+            if [ $NGX_RPATH = YES ]; then
+                ngx_feature_libs="-RHOMEBREW_PREFIX/lib -LHOMEBREW_PREFIX/lib -lpcre"
+            else
+                ngx_feature_libs="-LHOMEBREW_PREFIX/lib -lpcre"
+            fi
+
+            . auto/feature
+        fi
+
         if [ $ngx_found = yes ]; then
             CORE_DEPS="$CORE_DEPS $REGEX_DEPS"
             CORE_SRCS="$CORE_SRCS $REGEX_SRCS"
--- a/conf/nginx.conf
+++ b/conf/nginx.conf
@@ -33,7 +33,7 @@
     #gzip  on;

     server {
-        listen       80;
+        listen       8080;
         server_name  localhost;

         #charset koi8-r;
