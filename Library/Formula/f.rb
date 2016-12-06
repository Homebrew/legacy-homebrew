require 'formula'

class F < Formula
  homepage 'https://github.com/clvv/f'
  url 'https://github.com/clvv/f/tarball/master'
  md5 '46400b200cb607121edbd3bae476f9f0'

  head 'https://github.com/clvv/f.git'
  version '1'

  depends_on 'gawk'
  depends_on 'coreutils'

  def install
    (prefix+'etc/profile.d').install 'f.sh'
  end

  def caveats; <<-EOS.undent
    For Bash or Zsh, put something like this in your $HOME/.bashrc
    or $HOME/.zshrc:

     source `brew --prefix`/etc/profile.d/f.sh

    Optionally add these aliases:

     alias v='f -e vim' # quick opening files with vim
     alias m='f -e mplayer' # quick opening files with mplayer
     alias j='d -e cd' # quick cd into directories, mimicking autojump and z
     alias o='a -e xdg-open' # quick opening files with xdg-open

    EOS
  end
end
