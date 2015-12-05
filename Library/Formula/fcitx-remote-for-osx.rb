class FcitxRemoteForOsx < Formula
  desc "handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.0.2.tar.gz"
  sha256 "746505694090d98d5ad572758e7597c49d3bea1b00208a8272c3648aad15ad69"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f2e9c699eacc33980431176f93b47650c840af3dec8e8c1ca20be038a2d9e03" => :el_capitan
    sha256 "98bccbcc7fbab5f151549ca94f6167538733c5197d388bad340e38dd0a21fef3" => :yosemite
    sha256 "c7f9b8e28c380c8b325ceb85511b0d51f340bc871cb5d779f2b51157eaafc57f" => :mavericks
  end

  option "with-input-method=", "Select input method: baidu-pinyin(default), baidu-wubi, sogou-pinyin, qq-wubi, squirrel-rime, osx-pinyin"

  def install
    input_method = ARGV.value("with-input-method") || "baidu-pinyin"
    system "./build.py", "build", input_method
    bin.install "fcitx-remote-#{input_method}"
    bin.install_symlink "fcitx-remote-#{input_method}" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote"
  end
end
