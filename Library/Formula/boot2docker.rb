class Boot2docker < Formula
  desc "Lightweight Linux for Docker"
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git",
    :tag => "v1.7.1", :revision => "8fdc6f573bf08149b6311681800d55fda6e19e71"
  head "https://github.com/boot2docker/boot2docker-cli.git"

  bottle do
    cellar :any
    sha256 "ee635531a2ef65a83f026e71b5c807c98413793a5f736db66dbb0c7eb9053214" => :yosemite
    sha256 "6d72b9ce39f9c50fffa55c9314a2c7b0785ad32048722183f2c96ce29bd3e2cf" => :mavericks
    sha256 "26a9309721b6c04f031f652d06f34cf5f16f2dcbb710e2a8e73de8d8b7654b08" => :mountain_lion
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
