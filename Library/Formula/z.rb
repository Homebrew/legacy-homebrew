require 'formula'

class Z < Formula
  homepage 'https://github.com/rupa/z'
<<<<<<< HEAD
  url 'https://github.com/rupa/z/tarball/v1.2'
  sha1 '05b3d8dc761eb660f1d0d56258463cc45b2e097f'
=======
  url 'https://github.com/rupa/z/tarball/v1.3'
  sha1 '5c7b959fa4599ddde1e18cf5ffb048e1e3284140'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  head 'https://github.com/rupa/z.git'

  def install
    (prefix+'etc/profile.d').install 'z.sh'
    man1.install 'z.1'
  end

  def caveats; <<-EOS.undent
    For Bash, put something like this in your $HOME/.bashrc:

     . `brew --prefix`/etc/profile.d/z.sh

    For Zsh, put something like this in your $HOME/.zshrc:

     . `brew --prefix`/etc/profile.d/z.sh
     function precmd () {
       z --add "$(pwd -P)"
     }
    EOS
  end
end
