require "formula"
require "language/go"

class Fzf < Formula
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.9.10.tar.gz"
  sha1 "a76510e2f714c09c6122c13d569d35e75d525490"
  head 'https://github.com/junegunn/fzf.git'

  bottle do
    sha256 "0d4e78a2366149329fb9db7f6972972608f7b15a807fc0141ef050c5b7b08c4a" => :yosemite
    sha256 "74ec9e0f08a522036aaca48d5e4172452cba4be89e49228a34e4fc28c6bfebdf" => :mavericks
    sha256 "aff3a0dad4c15bf9478194436aa6588f0f51587ee0ea27a10dcc6a8c7f10aa7a" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/junegunn/go-shellwords" do
    url "https://github.com/junegunn/go-shellwords.git",
      :revision => "35d512af75e283aae4ca1fc3d44b159ed66189a4"
  end

  go_resource "github.com/junegunn/go-runewidth" do
    url "https://github.com/junegunn/go-runewidth.git",
      :revision => "63c378b851290989b19ca955468386485f118c65"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/junegunn"
    ln_s buildpath, buildpath/"src/github.com/junegunn/fzf"
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/fzf" do
      system "go", "build"
      bin.install "fzf"
    end

    prefix.install %w[install uninstall LICENSE]
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install "shell/completion.bash"
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats; <<-EOS.undent
    To install useful keybindings and fuzzy completion:
      #{prefix}/install

    To use fzf in Vim, add the following line to your .vimrc:
      set rtp+=#{prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($/)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
