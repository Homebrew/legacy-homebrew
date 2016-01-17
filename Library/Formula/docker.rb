class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.9.1",
      :revision => "a34a1d598c6096ed8b5ce5219e77d68e5cd85462"
  revision 1

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95dd6bae779945643e3380035fcee5aee3899c3c6eccf6573c0e5f119f91e0de" => :el_capitan
    sha256 "2e4d8fa1a23b98f5709b19173736a5c8742a29025d35695f8585298c531e52cf" => :yosemite
    sha256 "4033ae90e80faf0eae197e753f94d4b26461285ead526a3330ffc989cb283ef7" => :mavericks
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
