class Autojump < Formula
  homepage "https://github.com/joelthelion/autojump"
  url "https://github.com/joelthelion/autojump/archive/release-v22.2.4.tar.gz"
  sha1 "df9ff56e128efb8a8e1af574dbac9e4b3c47c1d6"

  head "https://github.com/joelthelion/autojump.git"

  def install
    inreplace "bin/autojump.sh", " /usr/local/share/autojump/", " #{prefix}/etc/"

    libexec.install "bin/autojump"
    libexec.install "bin/autojump_argparse.py", "bin/autojump_data.py", "bin/autojump_utils.py"
    man1.install "docs/autojump.1"
    (prefix/"etc").install "bin/autojump.sh", "bin/autojump.bash", "bin/autojump.zsh",
                           "bin/autojump.fish", "bin/autojump.tcsh"
    zsh_completion.install "bin/_j"

    bin.write_exec_script libexec+"autojump"
  end

  def caveats; <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      [[ -s $(brew --prefix)/etc/autojump.sh ]] && . $(brew --prefix)/etc/autojump.sh

    Add the following line to your ~/.config/fish/config.fish:
      . #{etc}/autojump.fish
    EOS
  end

  test do
    path = testpath/"foo"
    path.mkdir
    output = %x(
      source #{HOMEBREW_PREFIX}/etc/autojump.sh
      j -a foo
      j foo >/dev/null
      pwd
    ).strip
    assert_equal path.to_s, output
  end
end
