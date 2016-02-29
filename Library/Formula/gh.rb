class Gh < Formula
  desc "GitHub command-line client"
  homepage "https://github.com/jingweno/gh"
  url "https://github.com/jingweno/gh/archive/v2.1.0.tar.gz"
  sha256 "3435c95e78c71589c983e2cafa8948e1abf73aaa033e7fb9d891c052ce25f4f3"
  head "https://github.com/jingweno/gh.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "e2d0bc29c2f4b7eaf706955002ba1e88634aa4f2c0e0461b9d22b00e66da2734" => :el_capitan
    sha256 "553daabe8b4a839ce8f6403e78770d2fcb7773da9ac6b617a64e34bb52c3f70b" => :yosemite
    sha256 "541e522a0ccc06c007bed65b12ac60cd3db1e84c284aa878daecc24d628c17bf" => :mavericks
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    system "script/make", "--no-update"
    bin.install "gh"
    man1.install "man/gh.1"

    if build.with? "completions"
      bash_completion.install "etc/gh.bash_completion.sh"
      zsh_completion.install "etc/gh.zsh_completion" => "_gh"
    end
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal "bin/brew", `#{bin}/gh ls-files -- bin`.strip
    end
  end
end
