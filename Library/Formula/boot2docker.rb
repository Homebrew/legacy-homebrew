require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.0.1"
  head "https://github.com/boot2docker/boot2docker-cli.git", :branch => "master"

  bottle do
    sha1 "340e6d70eb17687b54f4c6072e731d516aeb3d91" => :mavericks
    sha1 "f97544fd168253ae16bd6db365c002dae3925d49" => :mountain_lion
    sha1 "7a950d1aaae96c9f05161155dd33ab75c01a778f" => :lion
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
