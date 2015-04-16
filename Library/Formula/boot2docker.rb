class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.6.0",
    :revision => "9894ae9dbe350c5b96602ed8b9bddb827d9b322b"
  head "https://github.com/boot2docker/boot2docker-cli.git"

  bottle do
    sha256 "c2601ede439f44981e76a1e4b015f02741567f13a236f9cca297e51636a201ed" => :yosemite
    sha256 "b030eecdf642ba8a0f39179eb6da4bc705f3f0f64ee6d4da675844a4216e4466" => :mavericks
    sha256 "4b60130534c13092d8b603a7171bb42269cdea621023664762544b583658c6be" => :mountain_lion
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
