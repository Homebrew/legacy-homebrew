class PcapDnsproxy < Formula
  desc "Powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.4.tar.gz"
  sha256 "4412e5f6b8bd1cf985f69132a1a38fcf3bf81ba83e9439920ae3237cf059816b"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad335026a30798983e778616a1ff74aa6befdccfd439e572ae0a494adec257af" => :el_capitan
    sha256 "1e53f35aa95fe4f8425f04fcbf314c03bafc1125331394f3d143b6016ca74c50" => :yosemite
    sha256 "6bfabcccc6cf62010d2de5713eb2aea2a65c25fb928d27747395b0edd7b84bd6" => :mavericks
  end

  depends_on :xcode => :build
  depends_on "libsodium" => :build

  def install
    rm Dir[buildpath/"Source/LibSodium/*"]
    ln_s "#{Formula["libsodium"].opt_lib}/libsodium.a", "#{buildpath}/Source/LibSodium/LibSodium_Mac.a"
    ln_s Dir[Formula["libsodium"].opt_include/"*"], "#{buildpath}/Source/LibSodium/"
    xcodebuild "-project", "./Source/KeyPairGenerator.xcodeproj", "-target", "KeyPairGenerator", "-configuration", "Release", "SYMROOT=build"
    xcodebuild "-project", "./Source/Pcap_DNSProxy.xcodeproj", "-target", "Pcap_DNSProxy", "-configuration", "Release", "SYMROOT=build"

    bin.install "Source/build/Release/KeyPairGenerator"
    bin.install "Source/build/Release/Pcap_DNSProxy"
    (etc/"pcap_DNSproxy").install Dir["Source/ExampleConfig/*.{ini,txt}"]
  end

  test do
    mkdir testpath/"pcap_dnsproxy"
    cp Dir[etc/"pcap_dnsproxy/*"], testpath/"pcap_dnsproxy/"
    inreplace testpath/"pcap_dnsproxy/Config.ini" do |s|
      s.gsub! /^Direct Request.*/, "Direct Request = IPv4 + IPv6"
      s.gsub! /^Operation Mode.*/, "Operation Mode = Proxy"
      s.gsub! /^Listen Port.*/, "Listen Port = 9999"
    end
    pid = fork { exec bin/"Pcap_DNSProxy", "-c", testpath/"pcap_dnsproxy/" }
    begin
      system "dig", "google.com", "@127.0.0.1", "-p", "9999", "+short"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end

  plist_options :startup => true, :manual => "sudo #{HOMEBREW_PREFIX}/opt/pcap_dnsproxy/bin/Pcap_DNSProxy -c #{HOMEBREW_PREFIX}/etc/pcap_dnsproxy/"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/Pcap_DNSProxy</string>
          <string>-c</string>
          <string>#{etc}/pcap_dnsproxy/</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
