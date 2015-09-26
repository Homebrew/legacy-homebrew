class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v0.6.0.tar.gz"
  sha256 "cfb270be1e480c70f0cea8eacf9828c2d7ef590532b8a88931ca58e1505183c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e66ded15ed8a9b800bdaabc7f11125c3a21aaf4664e045c42683f7ed3411f1ea" => :el_capitan
    sha256 "affb43c82c8195cb1b8aee16c28cc1dd8bd833890bf7dbdf6897cc1921916b2f" => :yosemite
    sha256 "5635d8e0e2ca15582f80edcff881be61ec9c864244461d4844b92801fb86e5b0" => :mavericks
    sha256 "666c7d305e5540bffbd3de3c9e970f5ba48ca01f4816047e772288b99a9613a8" => :mountain_lion
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
