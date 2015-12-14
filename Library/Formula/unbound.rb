class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://unbound.net/downloads/unbound-1.5.7.tar.gz"
  sha256 "4b2088e5aa81a2d48f6337c30c1cf7e99b2e2dc4f92e463b3bee626eee731ca8"

  bottle do
    cellar :any
    sha256 "fbfde16dc3317b8b1860f46627e44c7f61ebf5ab7a32012f3cecce7ef325435b" => :el_capitan
    sha256 "861d239840a865e8a1394c4c0ae0b84d95de2b51a45c7a3c503804494b9d53a0" => :yosemite
    sha256 "70c85a2de938b1346c004b3f8b556343b3cc54370a7eb3fc0f74ce2563c766c7" => :mavericks
  end

  depends_on "openssl"
  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make", "install"
  end

  def post_install
    if File.read(etc/"unbound/unbound.conf").include?('username: "@@HOMEBREW-UNBOUND-USER@@"')
      inreplace etc/"unbound/unbound.conf", 'username: "@@HOMEBREW-UNBOUND-USER@@"', "username: \"#{ENV["USER"]}\""
    end
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
