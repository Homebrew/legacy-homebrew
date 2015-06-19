class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.7.0",
    :revision => "0baf60984522744eed290348f33f396c046b2f3a"

  bottle do
    cellar :any
    sha256 "8c19fe17fc2fc8a9759b80aa1dd85e300336c123842fffedf768b22215c2b2bb" => :yosemite
    sha256 "ee5333ba2e6d67438d76c954503bb957790bff3dd0ba51e7645c5b8363de6313" => :mavericks
    sha256 "ca4e419285a250598f05d658fda3dac97c9b0bae4c3361086a9f13a41b40bfc7" => :mountain_lion
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_CLIENTONLY"] = "1"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/#{version}/dynbinary/docker-#{version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
