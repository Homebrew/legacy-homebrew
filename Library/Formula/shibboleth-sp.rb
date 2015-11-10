class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "http://shibboleth.net/downloads/service-provider/latest/shibboleth-sp-2.5.5.tar.gz"
  sha256 "30da36e0bba2ce4606a9effc37c05cd110dafdd6d3141468c4aa0f57ce4d96ce"

  depends_on "curl" => "with-openssl"
  depends_on "opensaml"
  depends_on "xml-tooling-c" => "with-openssl"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "log4shib"
  depends_on "boost"
  depends_on "homebrew/apache/httpd22" => :optional
  depends_on "homebrew/apache/httpd24" => :optional

  def apache_configdir
    if build.with? "httpd22"
      "#{etc}/apache2/2.2"
    elsif build.with? "httpd24"
      "#{etc}/apache2/2.4"
    else
      "/etc/apache2"
    end
  end

  def install
    ENV.O2
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]
    args << "--with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}"
    args << "--with-saml=#{Formula["opensaml"].opt_prefix}"
    args << "DYLD_LIBRARY_PATH=#{lib}"
    if build.with? "httpd22"
      args << "--enable-apache-22"
    elsif build.with? "httpd24"
      args << "--enable-apache-24"
    end
    system "./configure", *args
    system "make", "install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/shibd</string>
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
    s = ""
    s += <<-EOS.undent
      You must manually edit #{apache_configdir}/httpd.conf to include
    EOS
    if build.with? "httpd22"
      mod = "mod_shib_22.so"
    else
      mod = "mod_shib_24.so"
    end

    s += <<-EOS.undent
      LoadModule mod_shib #{lib}/shibboleth/#{mod}
    EOS

    s+= <<-EOS.undent
      You must also manually configure
        #{opt_prefix}/shibboleth-sp/etc/shibboleth/shibboleth2.xml
      as per your own requirements. For more information please see
        https://wiki.shibboleth.net/confluence/display/EDS10/3.1+Configuring+the+Service+Provider
    EOS
    s
  end

  def post_install
    unless File.exist? "#{prefix}/var/run/shibboleth"
      (prefix/"var/run/shibboleth/").mkpath
    end
    unless File.exist? "#{prefix}/var/cache/shibboleth"
      (prefix/"var/cache/shibboleth").mkpath
    end
  end

  test do
    system "#{opt_prefix}/sbin/shibd", "-t"
  end
end
