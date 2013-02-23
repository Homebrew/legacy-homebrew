require 'formula'

class Z < Formula
  homepage 'https://github.com/rupa/z'
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  url 'https://github.com/rupa/z/tarball/v1.2'
  sha1 '05b3d8dc761eb660f1d0d56258463cc45b2e097f'
=======
  url 'https://github.com/rupa/z/tarball/v1.3'
  sha1 '5c7b959fa4599ddde1e18cf5ffb048e1e3284140'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'https://github.com/rupa/z/tarball/v1.4'
  sha1 'c5ca4988fa75b02a8f68a05a8bfb6bfd28aa7d08'
>>>>>>> 82a1481f6fa824816bbf2bdeb53fd1933a1a15f2
=======
  url 'https://github.com/rupa/z/tarball/v1.5'
  sha1 '8a5286d6ed17b99259088e405fc2fcf923cf3b5f'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

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
