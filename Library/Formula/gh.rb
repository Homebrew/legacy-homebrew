require "formula"

class Gh < Formula
  homepage "https://github.com/jingweno/gh"
  url "https://github.com/jingweno/gh/archive/v2.1.0.zip"
  sha1 "42416b96029afdc9bbaaddc730321466087ce2ed"
  head "https://github.com/jingweno/gh.git"

  bottle do
  end

  depends_on "go" => :build

  option "without-completions", "Disable bash/zsh completions"

  def install
    system "script/make", "--no-update"
    bin.install "gh"

    if build.with? "completions"
      bash_completion.install "etc/gh.bash_completion.sh"
      zsh_completion.install "etc/gh.zsh_completion" => "_gh"
    end
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal 'bin/brew', `#{bin}/gh ls-files -- bin`.strip
    end
  end
end
