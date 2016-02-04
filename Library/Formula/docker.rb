class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.10.0",
      :revision => "590d5108bbdaabb05af590f76c9757daceb6d02e"

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe02c921afd6863be441b85ae069e24b7c5b13e97615b47c994ea8064e082bf1" => :el_capitan
    sha256 "8a3137f5d6155491e9c4833d80ca819d8bf6d31f38595be713baed06f5283c92" => :yosemite
    sha256 "282f987005f81d9a82269827b66aa1044dfbd8645c23845d59e21aad93dc99e0" => :mavericks
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
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
