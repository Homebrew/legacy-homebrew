class PcapDnsproxy < Formula
  desc "Powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.3.tar.gz"
  sha256 "6db76bbd51a54c77db45a525771b907fc1c29cf793989222e51a347be6506132"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    cellar :any
    sha256 "1149c60c0d6ab5aa81334b57761c86b7eb438ee84b9c7ea1439565eefbe29e52" => :yosemite
    sha256 "b8b14bf96e274af8309ea00697f8d9aeff495818b6383beabeff3a50807455de" => :mavericks
    sha256 "909e401f755a82d1a0bda205d66271618f8f67f611eda54fdfa8d57034c2fe9e" => :mountain_lion
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
      s.gsub! /^Direct Request.*/, "Direct Request = 1"
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
