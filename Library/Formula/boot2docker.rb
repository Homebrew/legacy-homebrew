class Boot2docker < Formula
  desc "Lightweight Linux for Docker"
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.7.0",
    :revision => "7d89508118ffbf5f3313cfa8a10d563942e3a643"
  head "https://github.com/boot2docker/boot2docker-cli.git"

  bottle do
    cellar :any
    sha256 "ea0db7efe7116c1d5795c8f28c89d84ce531e77b976bf888449aa5746a68c27c" => :yosemite
    sha256 "f411a66bb54e284941209b7030804ba58eab90b40276d62a366895998832e487" => :mavericks
    sha256 "548ef74e0660b4afcac2d5506f08bff302896e3179cf02617cb18d1513b04dcc" => :mountain_lion
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
