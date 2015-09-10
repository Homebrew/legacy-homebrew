class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v0.7.3.tar.gz"
  sha256 "947fd6dac603dcb02467cc2969ef26db1ccdc72312b6b0d70fb8d11179eb09ba"

  depends_on "dialog" => :recommended

  def install
    libexec.install Dir["src/*"]
    bin.write_exec_script Dir["#{libexec}/git-*"]
    man1.install Dir["man/man1/*"]
  end

  def caveats
    <<-EOS.undent
      To install the Fish shell autocompletions,
      run "git town install-fish-autocompletion"
      in the terminal.
    EOS
  end

  test do
    cd HOMEBREW_PREFIX do
      system "#{bin}/git-town", "config"
    end
  end
end
