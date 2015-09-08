class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v0.7.3.tar.gz"
  sha256 "947fd6dac603dcb02467cc2969ef26db1ccdc72312b6b0d70fb8d11179eb09ba"

  depends_on "dialog" => :recommended

  def install
    # Install the source
    libexec.install Dir["src/*"]

    # Symlink the executables
    bin.install_symlink Dir["#{libexec}/git-*"]
    bin.install_symlink "#{libexec}/helpers"
    bin.install_symlink "#{libexec}/drivers"

    # Install the man pages
    man1.install Dir["man/man1/*"]
  end

  def caveats
    <<-EOS.undent
      To install the Fish shell autocompletions,
      run "git town install-fish-autocompletion"
      in the terminal.

      To install the completions manually, make
      #{libexec}/autocomplete/git.fish
      available as ~/.config/fish/completions/git.fish.
      In a standard setup, this looks like:
      mkdir -p ~/.config/fish/completions
      ln -s #{libexec}/autocomplete/git.fish ~/.config/fish/completions/git.fish
    EOS
  end

  test do
    system "#{bin}/git-town", "version"
  end
end
