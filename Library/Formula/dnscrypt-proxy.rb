require 'formula'

class DnscryptProxy < Formula
  homepage 'http://dnscrypt.org'
  url 'http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.3.3.tar.bz2'
  sha256 'd9aca5253b9fe0fd0bb756201e837d3b723c091e5be0eb3a81cf5432cedaec47'

  head do
    url 'https://github.com/opendns/dnscrypt-proxy.git', :branch => 'master'

    depends_on :automake
    depends_on :libtool
  end

  option "plugins", "Support plugins and install example plugins."

  depends_on 'libsodium'

  def install
    system "autoreconf", "-if" if build.head?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.include? "plugins"
      args << "--enable-plugins"
      args << "--enable-relaxed-plugins-permissions"
      args << "--enable-plugins-root"
    end
    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    Once dnscrypt-proxy is running, you will have to update your local
    DNS server to point to 127.0.0.1 in order for it to actually work.
    This is generally done under System Preferences > Network > Advanced.
    Once there, you will see a "DNS" tab where you can enter a list of DNS
    servers. You will want to make sure that 127.0.0.1 is listed there first.

    Note: By default, dnscrypt-proxy runs on 127.0.0.1:53 under the "nobody" user.
    If you would like to change these settings, you will have to edit the plist file.

    To check that dnscrypt-proxy is running properly, open Terminal and enter this at
    the command prompt:

        nslookup -type=txt debug.opendns.com

    You should see something like this in the output:

        debug.opendns.com text = "dnscrypt enabled (...)"
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/sbin/dnscrypt-proxy</string>
          <string>--local-address=127.0.0.1:53</string>
          <string>--user=nobody</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end
