require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.3.0"
  head "https://github.com/boot2docker/boot2docker-cli.git", :branch => "master"

  bottle do
    revision 2
    sha1 "891132f91b6af4cba058c92cecd41287d2e1fc6d" => :mavericks
    sha1 "ec3342d2c6378aa6725eed021fd6cc801da79d31" => :mountain_lion
    sha1 "5c651fe2047ea0cd0512722d278631d39b6a19f8" => :lion
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
