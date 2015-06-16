class PcapDnsproxy < Formula
  desc "A powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.2.tar.gz"
  sha256 "0737b16283e84bc94f63066f448ba84416141b8d5a86b5e01f1f97164d9d44f2"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    cellar :any
    sha256 "5e618117b29e420fb1726ed1c4ef493a7bcd7610c1431445c879d4032c608f68" => :yosemite
    sha256 "8b814cd69b3af060da528aebd4bc4dca49fbb1977ed472df3a3d25277f91d635" => :mavericks
    sha256 "32d4fcc6f22ba124a3a9ded9322cc645aa8ca5bdb1bcd0a5abf6b458afe775e0" => :mountain_lion
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
      s.gsub! /^Hosts Only.*/, "Hosts Only = 1"
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
