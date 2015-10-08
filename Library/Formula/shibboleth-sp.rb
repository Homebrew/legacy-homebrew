class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "http://shibboleth.net/downloads/service-provider/latest/shibboleth-sp-2.5.5.tar.gz"
  sha256 "30da36e0bba2ce4606a9effc37c05cd110dafdd6d3141468c4aa0f57ce4d96ce"

  depends_on "opensaml"
  depends_on "xml-tooling-c"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "log4shib"
  depends_on "boost"

  def install
    ENV.O2
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-xmltooling=/usr/local/Cellar/xml-tooling-c/1.5.3",
                          "--with-saml=/usr/local/Cellar/opensaml/2.5.3",
                          "--with-boost=/usr/local/Cellar/boost/1.58.0",
                          "--with-xerces=/usr/local/Cellar/xerces-c/3.1.2",
                          "--with-xmlsec=/usr/local/Cellar/xml-security-c/1.7.3"
    system "make", "install"
    (var/"shibboleth/run").mkpath
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ServiceDescription</key>
      <string>Shibboleth 2 Service Provider daemon</string>
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
    </dict>
    </plist>
    EOS
  end
end
