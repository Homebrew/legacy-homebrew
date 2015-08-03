class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.1.tar.gz"
  sha256 "9350aba6a8e3da9d26b7258a4020bf84491af69595f7484f922d75fc8b86dc10"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any
    sha256 "ce82b60ae28c9d788e816276b12086b91e68c1c15b90b638fa380326e3846b66" => :yosemite
    sha256 "b995e7d96af5d5ac27236fd3317b24eccb89cbb50b3c02a77c49d023d8d27334" => :mavericks
    sha256 "00bfe4481c997341e41a564fa5f32abc87ca1ce735c7afede826c6d491863e81" => :mountain_lion
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    system "script/build"
    bin.install "hub"
    man1.install Dir["man/*"]

    if build.with? "completions"
      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
    end
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal "bin/brew", shell_output("#{bin}/hub ls-files -- bin").strip
    end
  end
end
