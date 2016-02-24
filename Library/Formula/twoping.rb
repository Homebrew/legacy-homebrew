class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "http://www.finnie.org/software/2ping/"
  url "http://www.finnie.org/software/2ping/2ping-3.2.0.tar.gz"
  sha256 "6297f7775be50d208f3b7d4925ecddb3ed1c593198fd875448ae8f88f1a6b196"
  head "https://github.com/rfinnie/2ping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2cec00cf5e8b1f5747c49072071688454d4d778ec251bd85e494c3f151c29ba" => :el_capitan
    sha256 "f78932d5c732c63038eabfd5c0839f1912b45ffd184d8505bd1d9f869663e714" => :yosemite
    sha256 "385c93c0cc7daf1e80c6afdc96da670cd389900b480795eb8fd0bd4905f40041" => :mavericks
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "2ping --listen", :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/2ping</string>
          <string>--listen</string>
          <string>--quiet</string>
        </array>
        <key>UserName</key>
        <string>nobody</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"2ping", "-c", "5", "test.2ping.net"
  end
end
