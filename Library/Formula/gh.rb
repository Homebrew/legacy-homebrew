require "formula"

class Gh < Formula
  homepage "https://github.com/jingweno/gh"
  head "https://github.com/jingweno/gh.git"
  url "https://github.com/jingweno/gh/archive/v0.25.1.tar.gz"
  sha1 '02a2010e07c859d361ceb47700ec2a8ee07a42a2'
  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = buildpath
    system 'go get github.com/jingweno/gh'
    bin.install "bin/gh"
    bash_completion.install "etc/gh.bash_completion.sh"
    zsh_completion.install "etc/gh.zsh_completion" => "_gh"
  end

  test do
    system "gh", "init"
    assert_file ".git"
  end
end
