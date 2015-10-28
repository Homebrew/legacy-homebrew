class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.0.2.tar.gz"
  sha256 "8cd7ff02cb9d0d829b1865b8d6a7c2901c07964274b73517d897620b9bc5256e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d0578d430ec5a360a88af51ccc1969cb115aa04c03bb229be5f7bf48ac0dd0c" => :el_capitan
    sha256 "bd64d355d2161b2ce2bc10dc1c6690afae64afd47ca17962d5bf3919d6042fe8" => :yosemite
    sha256 "f411b2c5e4408988f2d63766ec98e2108c843f840815203c50bcf21bde0267cb" => :mavericks
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
