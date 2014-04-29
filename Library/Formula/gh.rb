require "formula"

class Gh < Formula
  VERSION = "2.0.0"
  SOURCE_SHA1 = "ae44a538ca648efe1914d9ffb1af5ab23e2d879e"
  BOTTLE_SHA1 = "ba504c443f5fd289895e669dffa0eb67cd257add"

  homepage "https://github.com/jingweno/gh"
  url "https://github.com/jingweno/gh/archive/v#{VERSION}.zip"
  sha1 SOURCE_SHA1
  head "https://github.com/jingweno/gh.git"

  bottle do
    root_url "https://github.com/jingweno/gh/releases/download/v#{VERSION}"
    prefix :any
    cellar :any
    sha1 BOTTLE_SHA1 => :mavericks
  end

  depends_on "go" => :build

  option "without-completions", "Disable bash/zsh completions"

  def install
    system "script/make"
    bin.install "gh"

    if build.with? "completions"
      bash_completion.install "etc/gh.bash_completion.sh"
      zsh_completion.install "etc/gh.zsh_completion" => "_gh"
    end

    # disable autoupdate when installing through homebrew
    system "git config --global gh.autoUpdate never"
  end

  test do
    assert_equal VERSION, `#{bin}/gh version`.split.last
  end
end
