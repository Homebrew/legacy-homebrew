class Boot2docker < Formula
  desc "Lightweight Linux for Docker"
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.6.2",
    :revision => "cb2c3bcc890d8ee67bb76cc91ecf5b63927c97f9"
  head "https://github.com/boot2docker/boot2docker-cli.git"

  bottle do
    cellar :any
    sha256 "819b26b7e1fd2e14cece31244b9b3a481ad06dbeb4f6658d58be7ae5c1e2105f" => :yosemite
    sha256 "a6aff45bff1875366e6a307105c48b44bfb8ba1f5fda13099125a274bdedf73c" => :mavericks
    sha256 "1bbae6d9d9815ced2953df1f2749cb1d194b0fcc7a4e7574a8d91dfb2346d135" => :mountain_lion
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
