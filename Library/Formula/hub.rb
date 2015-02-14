class Hub < Formula
  homepage "http://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.0.tar.gz"
  sha1 "29744a370b71e5b054fd91e59472de6dbe573a91"
  head "https://github.com/github/hub.git"

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
