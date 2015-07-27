class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v0.5.3.tar.gz"
  sha256 "f4bddfc2a5b427f5a11afe621e9f0b039ab5588b81106153cf7785878b1194ab"

  bottle do
    cellar :any
    sha256 "64d049e5e8c0e5138b25a259fd4e3e44e323b9c963dc83a1d48a1759bccae90e" => :yosemite
    sha256 "c129806c1f4b9aabe7a8c53358894e9875c96ccc0d37326f5db9788ea93b58d6" => :mavericks
    sha256 "d171c299bd1b446be6a23adf2e84629e84c7fea050e5a499df6fa00862695efd" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    # These three lines can be removed with 0.5.3 as the bootstrap script has
    # now been fixed to set GOPATH again in:
    # https://github.com/github/git-lfs/pull/458
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/github"
    ln_s buildpath, buildpath/"src/github.com/github/git-lfs"

    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
