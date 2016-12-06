require 'formula'

class GitHooks < Formula
  head 'https://github.com/bleis-tift/Git-Hooks.git', :branch => 'rewrite'
  homepage 'https://github.com/bleis-tift/Git-Hooks'

#  depends_on 'git'

  def install
    system "perl", "Install.PL", "-v", "linux", "--prefix=" + prefix

    bin.install "commands/git-hooks"

    (prefix + "etc/zsh_completion.d").install "git-hooks-completion.zsh"
  end

  def caveats
    <<-EOL.undent
      If you have installed git-hooks, you can use settings below.

      You must set envirnment variable GIT_HOOKS_HOME to your startup script(like .bashrc).
        # BEGIN example. (write into $HOME/.bashrc if use bash)
        GIT_HOOKS_HOME=/usr/local/share/git-core/Git-Hooks; export GIT_HOOKS_HOME
        # END

      If you use zsh and want to completion git hooks, write below setting in .zshrc
        # BEGIN use git hooks completion
        source /usr/local/etc/zsh_completion.d/git-hooks-completion.zsh
        # END

      and run below
        $ git config --global alias.hooks hooks

      To use hooks defaultly, you would set to init.templatedir in config.
        $ git config --global init.templatedir #{prefix}/share/git-core/templates
    EOL
  end
end
