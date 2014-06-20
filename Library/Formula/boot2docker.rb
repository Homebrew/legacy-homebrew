require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.0.0"
  head "https://github.com/boot2docker/boot2docker-cli.git", :branch => "master"

  bottle do
    sha1 "c854d2d817ec505e13427fb43dab68ce746dda11" => :mavericks
    sha1 "c5ec44f2a8dd410e074e16e0e3a36a1e31456dd6" => :mountain_lion
    sha1 "a697e88858bb43bfc5c50f51fb555d78815ff391" => :lion
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
