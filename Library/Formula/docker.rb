require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.8.1"

  option "without-completions", "Disable bash/zsh completions"

  bottle do
    revision 2
    sha1 "6656fe911e1db382fbe704dbe9e0e68272f0ee01" => :mavericks
    sha1 "d73586890467d00728db185cf0550479e4b94628" => :mountain_lion
    sha1 "bd6595664d5384c4e1584864d96d409d475016ce" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GIT_DIR"] = cached_download/".git"
    ENV["AUTO_GOPATH"] = "1"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/0.8.1/dynbinary/docker-0.8.1" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
