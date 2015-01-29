class Autojump < Formula
  homepage "https://github.com/joelthelion/autojump"
  url "https://github.com/joelthelion/autojump/archive/release-v22.2.4.tar.gz"
  sha1 "df9ff56e128efb8a8e1af574dbac9e4b3c47c1d6"

  head "https://github.com/joelthelion/autojump.git"

  bottle do
    sha1 "d166d64df27ba146e99f57fd54a67255da2c6908" => :yosemite
    sha1 "903b1b5137cc95cf97f3ed7161770a961b46627a" => :mavericks
    sha1 "5570968a674c23d5f15092a4e438c860c03bd8a9" => :mountain_lion
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
