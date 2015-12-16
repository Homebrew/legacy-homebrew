class Beanstalk < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://kr.github.io/beanstalkd/"
  url "https://github.com/kr/beanstalkd/archive/v1.10.tar.gz"
  sha256 "923b1e195e168c2a91adcc75371231c26dcf23868ed3e0403cd4b1d662a52d59"

  bottle do
    sha256 "e33e39c6319ae92305b2dd810fd70bba6a61db2ab1a8e845d1bfb68b33756005" => :mavericks
    sha256 "ae3fe9c2c70291f524fc22fbf8df34e84283da8a885262f48262f87fe19178c2" => :mountain_lion
    sha256 "71eaae9e6f8d3db525780b84121511020887eebdb3dfb1d12e418c5a3e8b9e34" => :lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :manual => "beanstalkd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/beanstalkd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/beanstalkd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/beanstalkd.log</string>
      </dict>
    </plist>
    EOS
  end
end
