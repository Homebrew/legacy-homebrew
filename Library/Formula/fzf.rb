require "formula"
require "language/go"

class Fzf < Formula
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.9.3.tar.gz"
  sha1 "0d18bf1c084e31187910202ee1e2e6bdcf26d97a"

  bottle do
    sha1 "8df0dad7e5da5ea4211aa0069c9e04e107f26314" => :yosemite
    sha1 "9f760d6dd1a00d348675c08e1a643ab5433d95d6" => :mavericks
    sha1 "ca152e6e4f893f5581b93f809b47b9e80fc2b507" => :mountain_lion
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
