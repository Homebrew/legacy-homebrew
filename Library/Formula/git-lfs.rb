class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.1.0.tar.gz"
  sha256 "1f246ec5f1141677b05847b3e9bcb9929c9d9b1afc78585d5776a9c18186ea9b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f54208fbbd91d4f7135acf6137420c95034a997969123ef5fb5fa66571dd942f" => :el_capitan
    sha256 "f1a154600ce89dec9b02a11c54b33d80dc6f63088c5e469ba3a0e3ef802a8ad5" => :yosemite
    sha256 "ef8265bf1f41cb2ed3a31c12b567ec97623766938a57d3d475a01f5d74f26e69" => :mavericks
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
