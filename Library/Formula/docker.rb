class Docker < Formula
  homepage "https://www.docker.com/"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.6.1",
    :revision => "97cd073598275fa468fb3051952bd11002830c8e"

  bottle do
    cellar :any
    sha256 "01a307c67712357520c5bdc16bc244ac3c57bc293d90752e8bf555db3d38ed0c" => :yosemite
    sha256 "1b9a5376bcc0b55a5eb48a468e60d7bb463011b5bd5edbd5b52a8fa9854f9580" => :mavericks
    sha256 "0003bc36e3b8b7e5995f1cd5793661341d5f841d9cad63ab50881938df388904" => :mountain_lion
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
