class FcitxRemoteForOsx < Formula
  desc "handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.0.2.tar.gz"
  sha256 "746505694090d98d5ad572758e7597c49d3bea1b00208a8272c3648aad15ad69"

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
