class GitReplaceText < Formula
  desc "git sub-command to replace the text in the repository."
  homepage "https://github.com/ngtk/git-replace-text"
  url "https://github.com/ngtk/git-replace-text/archive/v0.0.2.tar.gz"
  sha256 "663c77fc7d4779de81c2277d663f97fba6b365387a080bcee43caa0c1fdcad81"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "git", "init"
    path = testpath/"happy.rb"
    content = "unhappy"
    path.write content
    system "git", "add", "."
    system "git", "commit", "-m", "unhappy..."

    system bin/"git-replace-text", "unhappy", "happy"
  end
end
