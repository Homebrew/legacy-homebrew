require "formula"

class Gh < Formula
  homepage "https://github.com/jingweno/gh"
  url "https://github.com/jingweno/gh/archive/v2.1.0.tar.gz"
  sha1 "0673343542fedd6780bdb1d5a773c45f35a9ab28"
  head "https://github.com/jingweno/gh.git"

  bottle do
    sha1 "8f4434cfa3a015ac92f22dd5b043d7c7ed5bd094" => :mavericks
    sha1 "c6fdfd0562cd00fd2c30aaeb9926e0372a5c31cf" => :mountain_lion
    sha1 "c910b882aec49ae1057c1510d79bf84acab8d447" => :lion
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
