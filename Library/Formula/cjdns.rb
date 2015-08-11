class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v16.1.tar.gz"
  sha256 "3eebb276ee63f103c54aa9201e67d8d810ae3a88af90300dd3a3a894e73cb400"

  bottle do
    cellar :any
    sha256 "0b87bde24768d2f23f87d0dc09fbb47cb05f99c438757939ede4d03b1fd0af3f" => :yosemite
    sha256 "16f751bff106f62330f10907394620743d5f043c640a65edaa392d74a068ecfb" => :mavericks
    sha256 "7868e1bb787eb0fd4c0039c2b70b7f6db0553438eb31d8c2bc98cc6d38381b95" => :mountain_lion
  end

  depends_on "node" => :build

  def install
    system "./do"
    bin.install "cjdroute"
    (share+"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
  end

  def caveats
    s = <<-EOS.undent
      !!!IMPORTANT!!!
      Before using cjdns, you must generate a configuration file and find peers manually.
      Once you have found eligible peers, use the following command to generate a config that is appropriate for Launchd
        sudo bash -c "cjdroute --genconf | sed 's@\\"noBackground\\":0@\\"noBackground\\":1@' > /etc/cjdroute.conf"
    EOS
  end

  plist_options :manual => "cjdroute"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>sudo</string>
          <string>bash</string>
          <string>-c</string>
          <string>/usr/local/bin/cjdroute &lt; /etc/cjdroute.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProcessType</key>
        <string>Interactive</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{share}/test/cjdroute_test", "all"
  end
end
