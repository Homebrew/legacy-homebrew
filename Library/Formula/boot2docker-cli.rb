require "formula"

class Boot2dockerCli < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v0.9.2"

  bottle do
    sha1 "764f4482f0b7384c9be65da1d82fa6d2e0d74d4a" => :mavericks
  end

  depends_on "docker" => :recommended
  depends_on "go" => :build

  conflicts_with "boot2docker", :because =>
    "boot2docker-cli is a go based replacement!"

  def install
    (buildpath + "src/github.com/boot2docker/boot2docker-cli").install \
        Dir[buildpath/"*"]

    cd "src/github.com/boot2docker/boot2docker-cli" do
      ENV["GOPATH"] = buildpath
      system "go get -d"

      ENV["GIT_DIR"] = cached_download/".git"
      system "make goinstall"
    end

    bin.install "bin/boot2docker-cli" => "boot2docker"
  end

  test do
    system "#{bin}/boot2docker", "version"
  end
end
