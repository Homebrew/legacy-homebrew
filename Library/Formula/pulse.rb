require "formula"

class Pulse < Formula
  homepage "https://ind.ie/pulse/"
  url "https://source.ind.ie/project/pulse.git", :tag => "0.1.3"
  head "https://source.ind.ie/project/pulse.git"

  bottle do
    sha1 "a74e7d0c530321cd9bd83fd382f28b53aa306606" => :yosemite
    sha1 "b85b68c551bbff3c5f5a3ca0c151d60687b4ebc3" => :mavericks
    sha1 "2e4797f4a3b1a51296beb61b60f2eb273c1155fb" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = cached_download/".gopath"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    hack_dir = cached_download/".gopath/src/source.ind.ie/project/"
    rm_rf  hack_dir
    mkdir_p hack_dir
    ln_s cached_download, "#{hack_dir}/pulse"
    ln_s cached_download/".git", ".git"

    system "./build.sh", "noupgrade"
    prefix.install %w{ CONTRIBUTING.md LICENSE README.md }
    bin.install "pulse"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>STNORESTART</key>
          <string>yes</string>
        </dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pulse</string>
          <string>-no-browser</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/pulse", "-generate", "./"
  end
end
