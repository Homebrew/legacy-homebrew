class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "http://shibboleth.net/downloads/service-provider/2.5.6/shibboleth-sp-2.5.6.tar.gz"
  sha256 "024739a7b5190aebecac913d9445719912c6e4e401bfe256a25ca75ab4e67ad5"

  bottle do
    sha256 "0b677a96f1db3fc05e77e2d19233c8e28e50db96813a533ba579e634844b8810" => :el_capitan
    sha256 "bc8acf35899aac2a824d7120c1f6e4076775df35e46fea14bfaa5f2884e221c9" => :yosemite
  end

  option "with-apache-22", "Build mod_shib_22.so instead of mod_shib_24.so"

  depends_on :macos => :yosemite
  depends_on "curl" => "with-openssl"
  depends_on "opensaml"
  depends_on "xml-tooling-c" => "with-openssl"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "log4shib"
  depends_on "boost"

  def install
    ENV.O2 # Os breaks the build
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      DYLD_LIBRARY_PATH=#{lib}
    ]
    if build.with? "apache-22"
      args << "--enable-apache-22"
    else
      args << "--enable-apache-24"
    end
    system "./configure", *args
    system "make", "install"
  end

  plist_options :startup => true, :manual => "shibd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/shibd</string>
        <string>-F</string>
        <string>-f</string>
        <string>-p</string>
        <string>#{prefix}/var/run/shibboleth/shibd.pid</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def caveats
    mod = (build.with? "apache-22")? "mod_shib_22.so" : "mod_shib_24.so"
    <<-EOS.undent
      You must manually edit httpd.conf to include
      LoadModule mod_shib #{lib}/shibboleth/#{mod}
      You must also manually configure
        #{etc}/shibboleth/shibboleth2.xml
      as per your own requirements. For more information please see
        https://wiki.shibboleth.net/confluence/display/EDS10/3.1+Configuring+the+Service+Provider
    EOS
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  test do
    system "#{opt_sbin}/shibd", "-t"
  end
end
