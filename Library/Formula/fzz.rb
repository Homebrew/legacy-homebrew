require "formula"

class Fzz < Formula
  homepage "https://github.com/mrnugget/fzz"
  url "https://github.com/mrnugget/fzz/archive/v0.0.1.tar.gz"
  sha1 "70b0326d3c7cbffafb327fa092eeaf647f65ea08"

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system 'go', 'build', '-o', 'fzz'
    bin.install 'fzz'
  end

  test do
    assert_equal "fzz 0.0.1\n", `#{bin}/fzz -v`
  end
end
