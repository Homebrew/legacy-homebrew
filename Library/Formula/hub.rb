class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.2.tar.gz"
  sha256 "610572ee903aea1fa8622c16ab7ddef2bd1bfec9f4854447ab8e0fbdbe6a0cae"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2b12e11689b28b7a4904ddbd16c56f467494c7ebfd87ceb45fc36af7e30ed06" => :el_capitan
    sha256 "fdce2380822cd7aa521ebb5457aa7fa7e475973d73af495d4c177ac98774d30c" => :yosemite
    sha256 "7ebe3c35adda13a0e8921e63f9dcd2a94b05c2b78eb2400504d4871a72ef07f8" => :mavericks
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
