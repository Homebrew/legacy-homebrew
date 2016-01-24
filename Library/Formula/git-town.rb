class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v0.10.0.tar.gz"
  sha256 "b012ea8736b6446bf73ca758815376eadc019c771fa2bbaaa142eb4f8bf2c971"

  bottle :unneeded

  conflicts_with "git-extras", :because => "git-town also ships a git-sync binary"

  def install
    libexec.install Dir["src/*"]
    bin.write_exec_script Dir["#{libexec}/git-*"]
    man1.install Dir["man/man1/*"]
  end

  def caveats; <<-EOS.undent
    To install the Fish shell autocompletions run:
      `git town install-fish-autocompletion`
    in your terminal.
  EOS
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
