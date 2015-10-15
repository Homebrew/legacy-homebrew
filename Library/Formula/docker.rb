class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git", :tag => "v1.8.3",
                                              :revision => "f4bf5c7026816785d9f63c07e87f9450a49f2403"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ceb072a0fc25ba8cb86d3d976dc734155687f8e207b256fb5fcd1bf08e31826" => :el_capitan
    sha256 "cfa0b70225a83872b95e455c52fae1c268f1e7afb61f5245ee003e1b35f559b6" => :yosemite
    sha256 "22851af3fe291be6db08441d9c99aa869b669b164fe0c22d3a64349a49c4cb52" => :mavericks
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
