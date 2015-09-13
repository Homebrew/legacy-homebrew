class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git", :tag => "v1.8.2",
                                              :revision => "0a8c2e3717cb3a6fe4e8cb10243cb06473052541"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11749ecc9059b44e13dd763533d3101f06d5d9bb14f4fdd20bac850fc0afd0ec" => :el_capitan
    sha256 "908a8ef86f628bbc53e32b701d6ab88cea1e32d52621590873fe385fa139a63f" => :yosemite
    sha256 "5fb99137428989886c168299aa553633884e2898ae17a1d1514d9875e6980417" => :mavericks
    sha256 "a78aa507edd9d8483ed66b6fc7c9ec9e4f7ed20f89c62c9401b8c65ec654c9fc" => :mountain_lion
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
