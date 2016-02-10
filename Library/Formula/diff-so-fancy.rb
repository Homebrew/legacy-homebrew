class DiffSoFancy < Formula
  desc "builds on the good-lookin' output of diff-highlight"
  homepage "https://github.com/stevemao/diff-so-fancy"
  url "https://github.com/stevemao/diff-so-fancy/archive/v0.1.2.tar.gz"
  sha256 "fa4ac51368ba6b942c6b346117e5f72cabb00ea3c29f834e3c4ca80972e19502"

  depends_on "gnu-sed"

  def install
    prefix.install Dir["*"]
    inreplace "#{prefix}/diff-so-fancy", "sed", "gsed"
    bin.install_symlink "#{prefix}/diff-so-fancy"
  end

  def caveats; <<-EOS.undent
    You probably now want to configure git to fancify all your diffs. Run:
      git config --global core.pager "diff-so-fancy | less --tabs=1,5 -R"

    so that `git diff` will use it. You can still bypass with `git --no-pager diff`.

    You may also want some fancier colours. Consider trying:
      git config --global color.diff-highlight.oldNormal "red bold"
      git config --global color.diff-highlight.oldHighlight "red bold 52"
      git config --global color.diff-highlight.newNormal "green bold"
      git config --global color.diff-highlight.newHighlight "green bold 22"
    EOS
  end

  test do
    system bin/"diff-so-fancy"
  end
end
