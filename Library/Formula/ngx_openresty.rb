require 'formula'

class NgxOpenresty < Formula
  url 'http://agentzh.org/misc/nginx/ngx_openresty-1.0.9.10.tar.gz'
  homepage 'http://openresty.org'
  md5 '0dccb7be2c026dcd84f8d3aa7394fbea'

  depends_on 'pcre'

  skip_clean 'logs'

  # Changes default port to 8080
  # Tell configure to look for pcre in HOMEBREW_PREFIX
  def patches
    DATA
  end

  def install

    args = ["--prefix=#{prefix}",
            "--with-http_ssl_module",
            "--with-pcre",
            "--conf-path=#{etc}/ngx_openresty/ngx_openresty.conf",
            "--pid-path=#{var}/run/ngx_openresty.pid",
            "--lock-path=#{var}/ngx_openresty/ngx_openresty.lock",
            "--sbin-path=#{sbin}/ngx_openresty",
            "--error-log-path=#{var}/log/ngx_openresty/error.log",
            "--http-log-path=#{var}/log/ngx_openresty/access.log"
            ]

    #todo add module configs

    system "./configure", *args
    system "make"
    system "make install"

    #todo set up differently so it reads as ngx_openresty
    #man8.install "build/nginx-1.0.9/objs/nginx.8"
    (var+'log/ngx_openresty').mkpath

    (prefix+'org.openresty.ngx_openresty.plist').write startup_plist
    (prefix+'org.openresty.ngx_openresty.plist').chmod 0644
  end

  def test
      system "#{sbin}/ngx_openresty -V"
  end

  def startup_plist
      return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>org.openresty.nginx</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{sbin}/ngx_openresty</string>
            <string>-g</string>
            <string>daemon off;</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
    </dict>
</plist>
EOPLIST
  end

  def caveats; <<-EOS.undent
    In the interest of allowing you to run `nginx` without `sudo`, the default
    port is set to localhost:8080.

    If you want to host pages on your local machine to the public, you should
    change that to localhost:80, and run `sudo nginx`. You'll need to turn off
    any other web servers running port 80, of course.

    You can start nginx automatically on login running as your user with:

        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.openresty.ngx_openresty.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.openresty.ngx_openresty.plist

    Though note that if running as your user, the launch agent will fail if you
    try to use a port below 1024 (such as http's default of 80.)
    EOS
  end

end

__END__
--- a/bundle/nginx-1.0.9/auto/lib/pcre/conf
+++ b/bundle/nginx-1.0.9/auto/lib/pcre/conf
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
--- a/bundle/nginx-1.0.9/conf/nginx.conf
+++ b/bundle/nginx-1.0.9/conf/nginx.conf
@@ -33,7 +33,7 @@ http {
     #gzip  on;

     server {
-        listen       80;
+        listen       8080;
         server_name  localhost;

         #charset koi8-r;

