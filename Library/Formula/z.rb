require 'formula'

class Z < Formula
  homepage 'https://github.com/rupa/z'
  url 'https://github.com/rupa/z/tarball/v1.1'
  md5 '75125fba5be0638dafd2518489d2faf2'

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

