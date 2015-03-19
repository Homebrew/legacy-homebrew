class Docker < Formula
  homepage "https://www.docker.com/"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.5.0",
    :revision => "a8a31eff10544860d2188dddabdee4d727545796"

  bottle do
    cellar :any
    sha1 "3eccd8879767b3fc95048f7d40a60edb69741892" => :yosemite
    sha1 "9e65954b48b3feb53ba14aafcd5081a5ede54809" => :mavericks
    sha1 "5f22268864f33697d6988a49c4c73ddc7368cfa2" => :mountain_lion
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
