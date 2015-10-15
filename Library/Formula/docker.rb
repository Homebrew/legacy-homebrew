class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git", :tag => "v1.8.3",
                                              :revision => "f4bf5c7026816785d9f63c07e87f9450a49f2403"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "228ff0f5f92a50cce224dcfa2174eb384aaceb9b94e9028db2ac20d7e05e81f3" => :el_capitan
    sha256 "b7a93b8fcb8e5bdbf14e5442722c2818525301829613ebd37a58070d83a1659b" => :yosemite
    sha256 "aaea412eb3152583818e04fb68e888bd09b3cdad0659d2a1d95f4246ac27d525" => :mavericks
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
