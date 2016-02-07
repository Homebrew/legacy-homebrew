class Gh < Formula
  desc "GitHub command-line client"
  homepage "https://github.com/jingweno/gh"
  url "https://github.com/jingweno/gh/archive/v2.1.0.tar.gz"
  sha256 "3435c95e78c71589c983e2cafa8948e1abf73aaa033e7fb9d891c052ce25f4f3"
  head "https://github.com/jingweno/gh.git"

  bottle do
    cellar :any
    revision 1
    sha256 "6e5a16713a79ff6c3d968fa87bc7aee977592fb72e3a1b8f9a47e444a49fa683" => :yosemite
    sha256 "922948d5e01dac8dc05ccdb632b4e5057b9344793bfb23d84c92c9d8d02eaeb9" => :mavericks
    sha256 "2806a27164b797b3707f326c4cb991dea35b6ebfa248abba7c5a87882afc3837" => :mountain_lion
    sha256 "dcb570e67b71ead8d4783186e34b04277cda000e94520f4fb1c0c1b85abe0265" => :lion
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
