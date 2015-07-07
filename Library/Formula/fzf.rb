require "formula"
require "language/go"

class Fzf < Formula
  desc "Fuzzy finder for your shell"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.10.0.tar.gz"
  sha256 "7d0b3ced40c99934590e3b0a2302a79ca13f36b7558d1643a89b1800021252ee"
  head 'https://github.com/junegunn/fzf.git'

  bottle do
    sha256 "d21d870c4bce187a71ab9062aaeabd6208ee6fb09706ec12c800abf90abeff3f" => :yosemite
    sha256 "d85bb6a9a35b2c78069e678233b586524df183ff52321e5ef87d48a2ff77ba00" => :mavericks
    sha256 "c64d25a89bc4a092d3e75ad8af5d02a128fc175e39b093949bcf79c1d50de8a4" => :mountain_lion
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
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
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
