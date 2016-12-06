require 'formula'

class TmuxVimSelectPane < Formula
  homepage 'https://github.com/derekprior/tmux-vim-select-pane'
  url 'https://github.com/derekprior/tmux-vim-select-pane/archive/v0.1.0.tar.gz'
  sha1 '8776b93b4cf3b91d932d6dff6a704da09f59c8fc'

  head 'https://github.com/derekprior/tmux-vim-select-pane.git'

  def install
    bin.install 'bin/tmux-vim-select-pane'
  end

  def caveats; <<-EOS.undent
    This script must be used in conjuntion with settings in your tmux
      configuration and with a vim plugin.

    Install the vim-tmux-navigator plugin here:
      https://github.com/christoomey/vim-tmux-navigator

    Add the following to ~/.tmux.conf
      # Smart pane switching with awareness of vim splits
      bind -n C-k run-shell 'tmux-vim-select-pane -U'
      bind -n C-j run-shell 'tmux-vim-select-pane -D'
      bind -n C-h run-shell 'tmux-vim-select-pane -L'
      bind -n C-l run-shell 'tmux-vim-select-pane -R'
      bind -n "C-\\\\" run-shell 'tmux-vim-select-pane -l'
    EOS
  end
end
