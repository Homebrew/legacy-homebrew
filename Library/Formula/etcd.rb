require 'formula'

class Etcd < Formula
  homepage 'https://github.com/coreos/etcd'
  url 'https://github.com/coreos/etcd/archive/v0.4.3.tar.gz'
  sha1 '88f44f3a09911fb60fcebcf0ea0f0bbeea2f9bf6'
  head 'https://github.com/coreos/etcd.git'

  bottle do
    sha1 "9ceffba554f95bc547cb792651981c9343d31201" => :mavericks
    sha1 "187638a52ae3950f4d7bd09f3d95080cd0ddc89a" => :mountain_lion
    sha1 "5de946891de46201dd7a24798fa7e442a335739d" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/etcd'
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/etcd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end
end
