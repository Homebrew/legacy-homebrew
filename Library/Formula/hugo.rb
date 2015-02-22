class Hugo < Formula
  homepage "http://gohugo.io/"
  head "https://github.com/spf13/hugo.git"
  url "https://github.com/spf13/hugo/archive/v0.13.tar.gz"
  sha1 "a821fcde92b03baf49a45970d0ae6b781a3b12c1"

  bottle do
    cellar :any
    revision 1
    sha1 "e892d9a0fb7c832fb7f24db8682d4775dfbcfd04" => :yosemite
    sha1 "42ad7067cabf84b2015e8086eb84115fce3c0e58" => :mavericks
    sha1 "f9c04d315507921b303aed2693438cbc9ef18ca1" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build
  depends_on :hg => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath
    system "go", "get"
    system "go", "build", "main.go"
    bin.install "main" => "hugo"
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert File.exist?("#{site}/config.toml")
  end
end
