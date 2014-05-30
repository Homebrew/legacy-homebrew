require 'formula'

class Autojump < Formula
  homepage 'https://github.com/joelthelion/autojump#name'
  url 'https://github.com/joelthelion/autojump/archive/release-v21.7.1.tar.gz'
  sha1 'bc19d40b3ebe29dc44da950f2c6dbd7da26fb6a3'

  head 'https://github.com/joelthelion/autojump.git'

  def install
    inreplace 'bin/autojump.sh', ' /etc/profile.d/', " #{prefix}/etc/"

    libexec.install 'bin/autojump'
    libexec.install 'bin/autojump_argparse.py', 'bin/autojump_data.py', 'bin/autojump_utils.py' if build.head?
    man1.install 'docs/autojump.1'
    (prefix/'etc').install 'bin/autojump.sh', 'bin/autojump.bash', 'bin/autojump.zsh'
    zsh_completion.install 'bin/_j'
    (prefix/'etc').install 'bin/autojump.fish' if build.head?

    bin.write_exec_script libexec+'autojump'
  end

  def caveats;
    msg = <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
    EOS

    if build.head?
      msg += <<-EOS.undent

      Add the following line to your ~/.config/fish/config.fish:
        . /usr/local/Cellar/autojump/HEAD/etc/autojump.fish
      EOS
    end

    msg
  end
end
