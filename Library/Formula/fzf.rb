require "language/go"

class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.11.4.tar.gz"
  sha256 "08871ad531c3931224721d4cd56651bf7d109c559a1bbdbfa7c787e3dd03d733"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f11bede99408f7b0352fb7ca87146201f138022ea188f2c06ee0586c583de013" => :el_capitan
    sha256 "f561a60e6a2ff9b94f1ba35f27e58722191b8ee2e963555349bb6c6737f0fdba" => :yosemite
    sha256 "5f382c442b25408e43a8fb4b11837ae1446845bd65799fb8c2ee6a59b2e11d2c" => :mavericks
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
      #{opt_prefix}/install

    To use fzf in Vim, add the following line to your .vimrc:
      set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($/)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
