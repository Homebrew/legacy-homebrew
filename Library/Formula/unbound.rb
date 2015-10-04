class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://unbound.net/downloads/unbound-1.5.4.tar.gz"
  sha256 "a1e1c1a578cf8447cb51f6033714035736a0f04444854a983123c094cc6fb137"

  depends_on "openssl"
  depends_on "libevent"

  bottle do
    cellar :any
    sha256 "6549666ba16f16923a9a5b78be8340e25e1ddc8546840034613c9547342668cb" => :el_capitan
    sha256 "6cfca30c6a6f4de11b21242ce77fd2b7ba9c1dfd6301ef8f440fb0db44fb2a1f" => :yosemite
    sha256 "312200fd62a1392bc2e52101b1e90a5651b0710707e51764e64da1ba66c38889" => :mavericks
    sha256 "b1b0ce7456c45862729e06ff4177dc9ec5023bd72f58bdd51d464bfa2d2d3b10" => :mountain_lion
  end

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
