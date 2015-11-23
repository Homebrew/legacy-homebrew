class Boot2docker < Formula
  desc "Lightweight Linux for Docker"
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git",
    :tag => "v1.8.0", :revision => "9a2606673efcfa282fb64a5a5c9e1b2f89d86fb4"
  head "https://github.com/boot2docker/boot2docker-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ba0d66cbf6945d807389d122f8e9978a268aabee3893fed98efab09251d4fb7" => :el_capitan
    sha256 "087e79bf9afee354f5a7ef8034ecb683b5645c82706a9fcbd34bf0bb5b71bfc7" => :yosemite
    sha256 "ca6772a87763b4690dd9e513d685a282bedeee689034f45828d66ffd19f79c37" => :mavericks
    sha256 "18ec9445c6c39777c0b390fa1ddf409817d62b3e17312778b77c29640f54a40e" => :mountain_lion
  end

  depends_on "docker" => :recommended
  depends_on "go" => :build

  def install
    (buildpath + "src/github.com/boot2docker/boot2docker-cli").install Dir[buildpath/"*"]

    cd "src/github.com/boot2docker/boot2docker-cli" do
      ENV["GOPATH"] = buildpath
      system "go", "get", "-d"
      system "make", "goinstall"
    end

    bin.install "bin/boot2docker-cli" => "boot2docker"
  end

  def caveats; <<-EOF.undent
      Rebuild the VM after an upgrade with:
        boot2docker destroy && boot2docker upgrade
    EOF
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/boot2docker</string>
        <string>up</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/boot2docker", "version"
  end
end
