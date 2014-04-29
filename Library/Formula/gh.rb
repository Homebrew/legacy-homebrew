require "formula"

class Gh < Formula
  homepage "https://github.com/jingweno/gh"
  url "https://github.com/jingweno/gh/archive/v2.0.0.zip"
  sha1 "ae44a538ca648efe1914d9ffb1af5ab23e2d879e"
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
