class Docker < Formula
  homepage "https://www.docker.com/"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.6.0",
    :revision => "47496519da9664202d900d3635bb840509fa9647"

  bottle do
    cellar :any
    sha256 "ef7f16ba999be4b9850507d67499e61520acb9924b5d24d98aeba30c7bc5bf24" => :yosemite
    sha256 "1996e13b08d24be9148e13ac75a3efad1afb616c02c397a064be833465bc1484" => :mavericks
    sha256 "d1b458d5266ba2d5ea5b2a2631490de53bce3343a406da1f05232855e36ef804" => :mountain_lion
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
