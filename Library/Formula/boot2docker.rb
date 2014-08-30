require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.2.0"
  head "https://github.com/boot2docker/boot2docker-cli.git", :branch => "master"

  bottle do
    sha1 "1746312fcef77f1d06e8fc40bb142facf6180810" => :mavericks
    sha1 "350c2f70ef4b0a0dcc750e827484f658320cd642" => :mountain_lion
    sha1 "cfa1c93c8b19deead435ff5d88ca0588d335b8b6" => :lion
  end

  depends_on "docker" => :recommended
  depends_on "go" => :build

  def install
    (buildpath + "src/github.com/boot2docker/boot2docker-cli").install Dir[buildpath/"*"]

    cd "src/github.com/boot2docker/boot2docker-cli" do
      ENV["GOPATH"] = buildpath
      system "go", "get", "-d"

      ENV["GIT_DIR"] = cached_download/".git"
      system "make", "goinstall"
    end

    bin.install "bin/boot2docker-cli" => "boot2docker"
  end

  test do
    system "#{bin}/boot2docker", "version"
  end
end
