class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git", :tag => "v1.8.1",
                                              :revision => "d12ea79c9de6d144ce6bc7ccfe41c507cca6fd35"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any
    sha256 "582ad19dc9f256d86e1b06ef0003cb6f2649bbd65e78d177b87f95e1fe474b6e" => :yosemite
    sha256 "4be7094557cfd607fee1cb1052407cbe94df2fef6ae452a7dbe16c946d35aa48" => :mavericks
    sha256 "5bfe9725910302068b7e47be7da53052920ba1a5ef163c38091fcc8e41d89d43" => :mountain_lion
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
