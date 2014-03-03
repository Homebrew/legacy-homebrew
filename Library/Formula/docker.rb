require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.8.1"

  option "without-completions", "Disable bash/zsh completions"

  bottle do
    sha1 "65c07eaf8d721f9270a12a1a129a01edd8ed186f" => :mavericks
    sha1 "b5de1b29b7db1ea6cd1a321c1f640d5618a8368c" => :mountain_lion
    sha1 "688cbc6dcbe651fe9e92fb9751bf4b7e9bcd5064" => :lion
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
