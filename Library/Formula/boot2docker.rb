class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.6.1",
    :revision => "076b58db9c502bb88827ffeb37c9d8f7d60b448e"
  head "https://github.com/boot2docker/boot2docker-cli.git"

  bottle do
    cellar :any
    sha256 "79bbb096673c9cbd5d2aa055398f9eba7ebcc68f86bda67fd85b2434bc1a8659" => :yosemite
    sha256 "ef4f58087fa345e5d85d0056f94f7692afa0146e995807826e1800d27c8f67e7" => :mavericks
    sha256 "4e958c197679934886c03992d8b742264fa0f0b7c568daeb69dec0b39ad0487a" => :mountain_lion
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
