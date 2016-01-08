class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.1.0.tar.gz"
  sha256 "1f246ec5f1141677b05847b3e9bcb9929c9d9b1afc78585d5776a9c18186ea9b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ab2a410d03e82d400b4a5d3da65d8b91994ad6fc38a5c5fa44e9dbcfc0a35fa" => :el_capitan
    sha256 "509e99813485ce9bfa0f1cd01118d37b7b9bb421a5dda59cfd6671f5e9acc15f" => :yosemite
    sha256 "b1110ee779264098a79f12ccad0e73e9fbd513d28ece61e0c485d34f8176377c" => :mavericks
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
