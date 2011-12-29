require 'formula'

class F < Formula
  homepage 'https://github.com/clvv/f'
  url 'https://github.com/clvv/f/tarball/0.3.7'
  head 'https://github.com/clvv/f.git'
  md5 '0748826eccee4c3a4778e09a01e1146a'

  def install
    (prefix+'etc/profile.d').install 'f.sh'
  end

  def caveats; <<-EOS.undent
    Source f in your shell configuration file:

      . `brew --prefix`/etc/profile.d/f.sh

    f comes with four useful aliases by default:

      alias a='_f -a'        # any
      alias d='_f -d'        # directory
      alias f='_f -f'        # file
      alias s='_f -s'        # show / search

    Add your own aliases to fully utilize the power of f:

      alias j='d -e cd'      # quickly cd into directories
      alias m='f -e mplayer' # quickly open files with mplayer
      alias o='a -e open'    # quickly open files with open
      alias v='f -e vim'     # quickly open files with vim

    If you use Zsh, you can key bind completion widgets:

      bindkey '^X^A' f-complete    # C-x C-a (files and directories)
      bindkey '^X^D' f-complete-d  # C-x C-d (directories)
      bindkey '^X^F' f-complete-f  # C-x C-f (files)
    EOS
  end
end

