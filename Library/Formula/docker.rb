class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.7.1",
    :revision => "786b29d4db80a6175e72b47a794ee044918ba734"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any
    sha256 "4a149ad01f976c8cd9d51aa56f3cc02281ba7990f80aa23f4e50fabcde1938fb" => :yosemite
    sha256 "cc07ad5c81a97180a4f17e4d9a7607440110bc3cf9955f916de4e281c1293cf1" => :mavericks
    sha256 "ea75c3fd9d1c3a2c8fb6194b7c20352ec63f17c06ab9243667e49b88154a9e7a" => :mountain_lion
  end

  option "with-experimental", "Enable experimental features"
  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_CLIENTONLY"] = "1"
    ENV["DOCKER_EXPERIMENTAL"] = "1" if build.with? "experimental"

    system "hack/make.sh", "dynbinary"

    build_version = build.head? ? File.read("VERSION").chomp : version
    bin.install "bundles/#{build_version}/dynbinary/docker-#{build_version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
