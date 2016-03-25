class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.3.0.tar.gz"
  sha256 "800f444b820b3a985e1da2d183fb5e2e23753a2ade53d6e1195678c650379a03"

  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1d061456b911c1a36216ee3e6569a73aad5e1e9994fb0ba515715a43675811e" => :el_capitan
    sha256 "08e603c2689a7ac96839cdd6b02f1c1b1803e50598dcd5eaef73d5b7d9275bc6" => :yosemite
    sha256 "374c3703dab50849119b2d511eeca5fa7523df903fa2ae34acf334c229343182" => :mavericks
  end

  def install
    system "./install.py", "-d", prefix, "-z", zsh_completion

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix/"etc").install_symlink prefix/"etc/profile.d/autojump.sh"

    libexec.install bin
    bin.write_exec_script libexec/"bin/autojump"
  end

  def caveats; <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

    If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
      [ -f #{HOMEBREW_PREFIX}/share/autojump/autojump.fish ]; and . #{HOMEBREW_PREFIX}/share/autojump/autojump.fish
    EOS
  end

  test do
    path = testpath/"foo"
    path.mkdir
    output = %x(
      source #{HOMEBREW_PREFIX}/etc/profile.d/autojump.sh
      j -a foo
      j foo >/dev/null
      pwd
    ).strip
    assert_equal path.to_s, output
  end
end
