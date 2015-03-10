require "formula"
require "language/go"

class Fzf < Formula
  homepage "https://github.com/junegunn/fzf"
  version "0.9.4-1"
  url "https://github.com/junegunn/fzf/archive/0.9.4-1.tar.gz"
  sha1 "cab72a79d9b7776d0a441d0ae1ba679893df8a55"

  bottle do
    cellar :any
    sha256 "c4cb36347952a935c7adffbc12afb9328394a3cde5608e39f03ff70fb9d7ade5" => :yosemite
    sha256 "3bd0df6eef42d1b3f72f4eec30b5504e97a4b0083e46ac90c92a2990c4293226" => :mavericks
    sha256 "1adcfa2199c2a6438bd185522e2015b1e64dfc5bc9059ef5e64ff35e7e202c2a" => :mountain_lion
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

    prefix.install %w[install uninstall fzf-completion.bash fzf-completion.zsh LICENSE]
    bin.install "bin/fzf-tmux"
    (prefix/"plugin").install "plugin/fzf.vim"
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
