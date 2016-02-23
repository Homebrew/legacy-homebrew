class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.10.2",
      :revision => "c3959b140f33c115c50710d2944dbf7e211bacd0"

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58521365298091423da2bb8db809241f6e48992e934e3272226c2bbc7ba6c0cc" => :el_capitan
    sha256 "b80066d6ccfac6d16227857d60ad00f6e96752cdb52e549a7a7e7d8a0f7e5dce" => :yosemite
    sha256 "d4700c8c1dbaf7531824db3e3537a75ee0b0d7d3389eae42a0f4222e54b26ad1" => :mavericks
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
