class Openlitespeed < Formula
  homepage "http://open.litespeedtech.com/mediawiki/"

  stable do
    url "http://open.litespeedtech.com/packages/openlitespeed-1.3.7.tgz"
    sha1 "b7028ca1981a64ce05b5189d655f51e2dc2cd204"
  end

  devel do
    url "http://open.litespeedtech.com/packages/openlitespeed-1.4.4.tgz"
    sha1 "fdab92f0d349f52908715440935bf4869197e636"

    depends_on "lua" => :optional
    depends_on "luajit" => :recommended
  end

  head do
    url "https://github.com/litespeedtech/openlitespeed.git"

    depends_on "lua" => :optional
    depends_on "luajit" => :recommended
  end

  option "with-debug", 'Enable debug build'
  option "with-spdy", 'Build with support for SPDY'
  option "with-libressl", 'Build with LibreSSL instead of OpenSSL'
  option "with-lua", 'Build with Lua instead of LuaJIT scripting for mod_lua'

  depends_on "pcre"
  depends_on "geoip"
  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional

  def install
    # Needed for correct ./configure detections.
    #ENV.enable_warnings

    # SSL Support
    if build.with? "libressl"
      libssl = Formula['libressl']
    else
      libssl = Formula['openssl']
    end

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-spdy",
            "--with-pcre=#{Formula['pcre'].opt_prefix}",
            "--with-openssl=#{libssl.opt_prefix}",
            "--with-user=#{ENV['USER']}",
            "--with-group=admin"
           ]
    args << "--enable-debug" if build.with? 'debug'

    if build.devel? or build.head?
      if build.with? 'lua'
        lua = Formula["lua"]
      else
        lua = Formula["luajit"]
      end
      args << "--with-lua=#{lua.opt_prefix}/include"
    end

    ENV['CPPFLAGS'] = "-I#{Formula['pcre'].opt_prefix}/include -I#{lua.opt_prefix}/include -I#{libssl.opt_prefix}/include"
    ENV['LDFLAGS']  = "-L#{Formula['pcre'].opt_prefix}/lib -L#{lua.opt_prefix}/lib -L#{libssl.opt_prefix}/lib"

    system "./configure", *args
    system "make", "install"
  end
end
