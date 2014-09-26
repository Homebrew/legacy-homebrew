require "formula"

class Nginx < Formula
  homepage "http://nginx.org/"
  url "http://nginx.org/download/nginx-1.6.1.tar.gz"
  sha1 "e58c865f67b580541ed4eadf69d1676762bf50ab"
  revision 1

  devel do
    url "http://nginx.org/download/nginx-1.7.4.tar.gz"
    sha1 "94f4ac8ddb4a05349e75c43b84f24dbacdbac6e9"
  end

  head "http://hg.nginx.org/nginx/", :using => :hg

  bottle do
    revision 1
    sha1 "c7c3ffae58d4ca2c95fcfb2a9dedbd55152fceb9" => :mavericks
    sha1 "7da4933d23f1cef378387b8abdb7c2981d20ea5a" => :mountain_lion
    sha1 "d688d641fd345be01efcc98e6aa65224f9ba3167" => :lion
  end

  env :userpaths

  # Before submitting more options to this formula please check they aren't
  # already in Homebrew/homebrew-nginx/nginx-full:
  # https://github.com/Homebrew/homebrew-nginx/blob/master/nginx-full.rb
  option "with-passenger", "Compile with support for Phusion Passenger module"
  option "with-webdav", "Compile with support for WebDAV module"
  option "with-debug", "Compile with support for debug log"
  option "with-spdy", "Compile with support for SPDY module"
  option "with-gunzip", "Compile with support for gunzip module"

  depends_on "pcre"
  depends_on "passenger" => :optional
  depends_on "openssl"

  def passenger_config_args
    passenger_config = "#{HOMEBREW_PREFIX}/opt/passenger/bin/passenger-config"
    nginx_ext = `#{passenger_config} --nginx-addon-dir`.chomp

    if File.directory?(nginx_ext)
      return "--add-module=#{nginx_ext}"
    end

    puts "Unable to install nginx with passenger support."
    exit
  end

  def install
    # Changes default port to 8080
    inreplace "conf/nginx.conf", "listen       80;", "listen       8080;"

    pcre = Formula["pcre"]
    openssl = Formula["openssl"]
    cc_opt = "-I#{pcre.include} -I#{openssl.include}"
    ld_opt = "-L#{pcre.lib} -L#{openssl.lib}"

    args = ["--prefix=#{prefix}",
            "--with-http_ssl_module",
            "--with-pcre",
            "--with-ipv6",
            "--sbin-path=#{bin}/nginx",
            "--with-cc-opt=#{cc_opt}",
            "--with-ld-opt=#{ld_opt}",
            "--conf-path=#{etc}/nginx/nginx.conf",
            "--pid-path=#{var}/run/nginx.pid",
            "--lock-path=#{var}/run/nginx.lock",
            "--http-client-body-temp-path=#{var}/run/nginx/client_body_temp",
            "--http-proxy-temp-path=#{var}/run/nginx/proxy_temp",
            "--http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp",
            "--http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp",
            "--http-scgi-temp-path=#{var}/run/nginx/scgi_temp",
            "--http-log-path=#{var}/log/nginx/access.log",
            "--error-log-path=#{var}/log/nginx/error.log",
            "--with-http_gzip_static_module"
          ]

    args << passenger_config_args if build.with? "passenger"
    args << "--with-http_dav_module" if build.with? "webdav"
    args << "--with-debug" if build.with? "debug"
    args << "--with-http_spdy_module" if build.with? "spdy"
    args << "--with-http_gunzip_module" if build.with? "gunzip"

    if build.head?
      system "./auto/configure", *args
    else
      system "./configure", *args
    end
    system "make"
    system "make install"
    man8.install "objs/nginx.8"
    (var/"run/nginx").mkpath
  end

  def post_install
    # nginx's docroot is #{prefix}/html, this isn't useful, so we symlink it
    # to #{HOMEBREW_PREFIX}/var/www. The reason we symlink instead of patching
    # is so the user can redirect it easily to something else if they choose.
    html = prefix/"html"
    dst  = var/"www"

    if dst.exist?
      html.rmtree
      dst.mkpath
    else
      dst.dirname.mkpath
      html.rename(dst)
    end

    prefix.install_symlink dst => "html"

    # for most of this formula's life the binary has been placed in sbin
    # and Homebrew used to suggest the user copy the plist for nginx to their
    # ~/Library/LaunchAgents directory. So we need to have a symlink there
    # for such cases
    if rack.subdirs.any? { |d| d.join("sbin").directory? }
      sbin.install_symlink bin/"nginx"
    end
  end

  test do
    system "#{bin}/nginx", "-t"
  end

  def passenger_caveats; <<-EOS.undent

    To activate Phusion Passenger, add this to #{etc}/nginx/nginx.conf, inside the 'http' context:
      passenger_root #{HOMEBREW_PREFIX}/opt/passenger/libexec/lib/phusion_passenger/locations.ini;
      passenger_ruby /usr/bin/ruby;
    EOS
  end

  def caveats
    s = <<-EOS.undent
    Docroot is: #{HOMEBREW_PREFIX}/var/www

    The default port has been set in #{HOMEBREW_PREFIX}/etc/nginx/nginx.conf to 8080 so that
    nginx can run without sudo.
    EOS
    s << passenger_caveats if build.with? "passenger"
    s
  end

  plist_options :manual => "nginx"

  def plist; <<-EOS.undent
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
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/nginx</string>
            <string>-g</string>
            <string>daemon off;</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
