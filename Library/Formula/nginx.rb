require 'formula'

class Nginx < Formula
  homepage 'http://nginx.org/'
  url 'http://nginx.org/download/nginx-1.0.1.tar.gz'
  md5 '4d4e70e3c6c907cb101c97e9cf9399c8'

  depends_on 'pcre'

  skip_clean 'logs'

  def patches
    # Changes default port to 8080
    # Set configure to look in homebrew prefix for pcre
    DATA
  end

  def options
    [
      ['--with-passenger', "Compile with support for Phusion Passenger module"],
      ['--with-webdav',    "Compile with support for WebDAV module"],
      ['--with-gzip',      "Compile with support for Gzip static module"],
      ['--with-realip',    "Compile with support for Realip module"],
      ['--with-upload',    "Compile with support for Upload and Upload Progress module"],
      ['--with-gru',       "Shortcut for --with-gzip, --with-realip, --with-upload"]
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

  def upload_install_args
    `mkdir /tmp/nginx_upload; mkdir /tmp/nginx_upload-progress`
    `curl -o /tmp/nginx_upload.tar.gz http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.tar.gz`
    `tar xzf /tmp/nginx_upload.tar.gz --directory /tmp/nginx_upload --strip 1`
    `curl -o /tmp/nginx_upload-progress.tar.gz https://download.github.com/masterzen-nginx-upload-progress-module-v0.8.2-0-g8b55a34.tar.gz`
    `tar xzf /tmp/nginx_upload-progress.tar.gz  --directory /tmp/nginx_upload-progress --strip 1`
    
    return ["--add-module=/tmp/nginx_upload" ""]
  end

  def install
    args = ["--user=nobody",
            "--group=nobody",
            "--prefix=#{prefix}",
            "--with-http_ssl_module",
            "--with-pcre",
            "--conf-path=#{etc}/nginx/nginx.conf",
            "--pid-path=#{var}/run/nginx.pid",
            "--lock-path=#{var}/nginx/nginx.lock",
            "--http-log-path=#{var}/nginx/log/default_access_log",
            "--error-log-path=#{var}/nginx/log/default_error_log",
            "--http-client-body-temp-path=#{var}/tmp/nginx/client",
            "--http-proxy-temp-path=#{var}/tmp/nginx/proxy"]

    args << passenger_config_args if ARGV.include? '--with-passenger'
    args << "--with-http_dav_module" if ARGV.include? '--with-webdav'
    
    if ARGV.include? '--with-gru'
      args << "--with-http_gzip_static_module"
      args << "--with-http_realip_module"
      args << "--add-module=/tmp/nginx_upload"
      args << "--add-module=/tmp/nginx_upload-progress"
    else
      args << "--with-http_gzip_static_module" if ARGV.include? '--with-gzip'
      args << "--with-http_realip_module" if ARGV.include? '--with-realip'
      args << upload_install_args if ARGV.include? '--with-upload'
    end
    
    system "./configure", *args
    system "make install"

    (prefix+'org.nginx.plist').write startup_plist
  end

  def caveats
    <<-CAVEATS
In the interest of allowing you to run `nginx` without `sudo`, the default
port is set to localhost:8080.

If you want to host pages on your local machine to the public, you should
change that to localhost:80, and run `sudo nginx`. You'll need to turn off
any other web servers running port 80, of course.

You can start nginx automatically on login with:
    mkdir -p ~/Library/LaunchAgents
    cp #{prefix}/org.nginx.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.nginx.plist

    CAVEATS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.nginx</string>
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
@@ -155,6 +155,22 @@ else
             . auto/feature
         fi

+        if [ $ngx_found = no ]; then
+
+            # Homebrew
+            HOMEBREW_PREFIX=${NGX_PREFIX%Cellar*}
+            ngx_feature="PCRE library in ${HOMEBREW_PREFIX}"
+            ngx_feature_path="${HOMEBREW_PREFIX}/include"
+
+            if [ $NGX_RPATH = YES ]; then
+                ngx_feature_libs="-R${HOMEBREW_PREFIX}/lib -L${HOMEBREW_PREFIX}/lib -lpcre"
+            else
+                ngx_feature_libs="-L${HOMEBREW_PREFIX}/lib -lpcre"
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
