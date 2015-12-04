class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://unbound.net/downloads/unbound-1.5.6.tar.gz"
  sha256 "ad3823f5895f59da9e408ea273fcf81d8a76914c18864fba256d7f140b83e404"

  bottle do
    cellar :any
    sha256 "5478c4b2c340bb1dd8689039fbe2a95375bdacf7a83e33530482fe99f1af675c" => :el_capitan
    sha256 "c6338a9b564f24b91f511eee53cb38e27132f69537f6b0f317043f2d7c383874" => :yosemite
    sha256 "049c3cd6c2dea2a82007ee0ce019e5c0e964367fc7abff040903d22d72537aaa" => :mavericks
  end

  depends_on "openssl"
  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  def post_install
    inreplace etc/"unbound/unbound.conf", 'username: "unbound"', "username: \"#{ENV["USER"]}\""
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
          <string>#{opt_sbin}/unbound</string>
          <string>-d</string>
          <string>-c</string>
          <string>#{etc}/unbound/unbound.conf</string>
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

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
