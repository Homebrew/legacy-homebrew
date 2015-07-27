class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v0.5.3.tar.gz"
  sha256 "f4bddfc2a5b427f5a11afe621e9f0b039ab5588b81106153cf7785878b1194ab"

  bottle do
    cellar :any
    sha256 "6afb84bae5e83a279ef0a8066c0b61fd40e05781e6c4776ee77fb972333626ee" => :yosemite
    sha256 "aeb74184e39e1da4fd8c423e18ced3bda58007bbe801cb88b3b44b36f854bab4" => :mavericks
    sha256 "7802d0702273c0d44e76288fada6eaed83c963a82a9885ab136bdd53b3bea276" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
