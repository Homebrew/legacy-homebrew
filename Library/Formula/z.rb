require 'formula'

class Z < Formula
  homepage 'https://github.com/rupa/z'
  url 'https://github.com/rupa/z/tarball/v1.5'
  sha1 '8a5286d6ed17b99259088e405fc2fcf923cf3b5f'

  head 'https://github.com/rupa/z.git'

  def install
    (prefix/'etc/profile.d').install 'z.sh'
    man1.install 'z.1'
  end

  def caveats; <<-EOS.undent
    For Bash or Zsh, put something like this in your $HOME/.bashrc or $HOME/.zshrc:
      . `brew --prefix`/etc/profile.d/z.sh

    ZSH USERS BACKWARD COMPATIBILITY WARNING:
     z now handles 'precmd' set up for zsh. z (<=1.3) users using zsh should
     remove the precmd function that was described in the installation
     instructions for previous versions.

    In short, this:
      . /path/to/z.sh
      function precmd () {
       _z --add "$(pwd -P)"
      }

    should now be:
      . `brew --prefix`/etc/profile.d/z.sh
    EOS
  end
end
