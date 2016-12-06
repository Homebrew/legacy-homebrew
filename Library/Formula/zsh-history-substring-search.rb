require 'formula'

class ZshHistorySubstringSearch < Formula
  homepage 'https://github.com/zsh-users/zsh-history-substring-search'
  url 'https://github.com/dongweiming/zsh-history-substring-search/archive/v0.1.tar.gz'
  sha1 '7edff8645b4a665dc89c201fa456ddd334e4716f'

  def install
    (share/'zsh-history-substring-search').install Dir['*']
  end

  def caveats
    <<-EOS.undent
    To activate the syntax highlighting, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

    Bind keyboard shortcuts to this script's functions:

        # bind UP and DOWN arrow keys
        for keycode in '[' 'O'; do
        bindkey "^[${keycode}A" history-substring-search-up
        bindkey "^[${keycode}B" history-substring-search-down
        done
        unset keycode

        # bind P and N for EMACS mode
        bindkey -M emacs '^P' history-substring-search-up
        bindkey -M emacs '^N' history-substring-search-down

        # bind k and j for VI mode
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down


    You will also need to force reload of your .zshrc:

        source ~/.zshrc

    If you want to use zsh-syntax-highlighting along with this script, then make sure that you load it before you load this script:

        % source zsh-syntax-highlighting.zsh
        % source zsh-history-substring-search.zsh

    EOS
  end
end
