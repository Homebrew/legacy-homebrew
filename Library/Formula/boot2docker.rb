require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.1.1"
  head "https://github.com/boot2docker/boot2docker-cli.git", :branch => "master"

  bottle do
    sha1 "3bb9ca2e51a8df571763409eb8ee9c371199cc4d" => :mavericks
    sha1 "79cceff57ba22ef1ddb0e2f75028f215cceb4532" => :mountain_lion
    sha1 "9e6ee45dade5e24163506e0c55d46c26c99653c3" => :lion
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
