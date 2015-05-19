class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.6.2",
    :revision => "7c8fca2ddb58c8d2c4fb4df31c242886df7dd257"

  bottle do
    cellar :any
    sha256 "8139ce8f2f2bd6e3217e33a07d6bb5f8df2666a37c720ca9116d22fefb937f1b" => :yosemite
    sha256 "af05ca45e1d041333351576cdda888fab81dd233690061cba709ae00cadf1c32" => :mavericks
    sha256 "94e5d68a79447b14d7ca3d64ce05aa0a471c57a89ccee295e3281049ddf5628a" => :mountain_lion
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_CLIENTONLY"] = "1"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/#{version}/dynbinary/docker-#{version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
