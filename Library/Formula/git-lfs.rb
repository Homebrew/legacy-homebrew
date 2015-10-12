class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.0.0.tar.gz"
  sha256 "bd9d0d597b36421babf282680d34d66b626facea63f68fc64399ac9fe70d2dd3"

  bottle do
    cellar :any_skip_relocation
    sha256 "141164e71595da8f8b6138e42b5f6050a0d7968c56c01ffa722a07b54bdfe2cf" => :el_capitan
    sha256 "117c48f958a15f3aa8ab08bbaa36e850b98ac9e1baa0e00403cc5e73621a831b" => :yosemite
    sha256 "69e3aee9a07da25e1e67e2b0e6f7b7a10772f9850c5a509d0740fdb36ef9edd4" => :mavericks
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
