class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git", :tag => "v1.9.0",
                                              :revision => "76d6bc9a9f1690e16f3721ba165364688b626de2"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec291732230609b2bb5c756e5cf3b021347f856c70371f343deb462479b2e3c7" => :el_capitan
    sha256 "e99070e33cc77c687cf09cdd10ebd71d04ffa8a9026ed90cc7a64c108a96088e" => :yosemite
    sha256 "b7247cb6ab7a55a08ea7a4c66d8b480cd5550e1cb1e610f2452e48e5836029e9" => :mavericks
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
