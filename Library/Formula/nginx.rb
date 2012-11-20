require 'formula'

class Nginx < Formula
  homepage 'http://nginx.org/'
  url 'http://nginx.org/download/nginx-1.2.5.tar.gz'
  sha1 'c36feaadbaad6938b02f4038c2d68cab10907f59'

  devel do
    url 'http://nginx.org/download/nginx-1.3.8.tar.gz'
    sha1 '84ff39e3f76e9f496f4e05080885e04caf472bb9'
  end

  UPLOAD_MODULE_VERSION = '2.2.0'
  UPLOAD_PROGRESS_VERSION = 'v0.9.0'

  env :userpaths

  depends_on 'pcre'

  option 'with-passenger', 'Compile with support for Phusion Passenger module'
  option 'with-webdav', 'Compile with support for WebDAV module'
  option 'with-upload-module', 'Compile with support for Upload and Upload-Progress modules.'

  skip_clean 'logs'

  # Changes default port to 8080
  def patches
    DATA
  end

  def download_upload_modules
    modules_dir = File.join(prefix, 'modules')
    upload_mod_name = "nginx_upload_module-#{UPLOAD_MODULE_VERSION}"
    progress_mod_name = "masterzen-nginx-upload-progress-module-#{UPLOAD_PROGRESS_VERSION}"
    upload_mod_dir = File.join(modules_dir, upload_mod_name)
    progress_mod_dir = File.join(modules_dir, progress_mod_name)

    FileUtils.mkdir_p modules_dir

    `curl http://www.grid.net.ru/nginx/download/#{upload_mod_name}.tar.gz | tar -xzf - && mv nginx_upload_module-* #{upload_mod_dir}`
    `curl -L https://github.com/masterzen/nginx-upload-progress-module/tarball/#{UPLOAD_PROGRESS_VERSION} | tar -xzf - && mv masterzen-* #{progress_mod_dir}`

    return upload_mod_dir, progress_mod_dir
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
    args = [
      "--prefix=#{prefix}",
      "--with-http_ssl_module",
      "--with-pcre",
      "--with-ipv6",
      "--with-cc-opt=-I#{HOMEBREW_PREFIX}/include",
      "--with-ld-opt=-L#{HOMEBREW_PREFIX}/lib",
      "--conf-path=#{etc}/nginx/nginx.conf",
      "--pid-path=#{var}/run/nginx.pid",
      "--lock-path=#{var}/run/nginx.lock",
      "--http-client-body-temp-path=#{var}/run/nginx/client_body_temp",
      "--http-proxy-temp-path=#{var}/run/nginx/proxy_temp",
      "--http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp",
      "--http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp",
      "--http-scgi-temp-path=#{var}/run/nginx/scgi_temp"
    ]

    args << passenger_config_args if build.include? 'with-passenger'
    args << '--with-http_dav_module' if build.include? 'with-webdav'
    if build.include? 'with-upload-module'
      upload_mod, progress_mod = download_upload_modules

      args << "--add-module=#{upload_mod}"
      args << "--add-module=#{progress_mod}"
    end

    system './configure', *args
    system 'make'
    system 'make install'
    man8.install 'objs/nginx.8'
    (var/'run/nginx').mkpath
  end

  def caveats; <<-EOS.undent
    In the interest of allowing you to run `nginx` without `sudo`, the default
    port is set to localhost:8080.

    If you want to host pages on your local machine to the public, you should
    change that to localhost:80, and run `sudo nginx`. You'll need to turn off
    any other web servers running port 80, of course.

    You can start nginx automatically on login running as your user with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

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
    <string>#{plist_name}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/sbin/nginx</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
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
