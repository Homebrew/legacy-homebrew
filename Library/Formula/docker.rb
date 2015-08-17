class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git", :tag => "v1.8.1",
                                              :revision => "d12ea79c9de6d144ce6bc7ccfe41c507cca6fd35"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any
    sha256 "c462e7f8e35f6a3a24c92e77adf6d9edaeca0677b5d7b0f2e265b60e6bb2690b" => :yosemite
    sha256 "a2f91f72b04ee275d484e887fe679ba16190991aba46c3a4845b63c714dc1726" => :mavericks
    sha256 "6ef8a317664148cc3af5939468a577bde2090bd65814c2ae7ea66fd5f5809e01" => :mountain_lion
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
