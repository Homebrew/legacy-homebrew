# -*- coding: utf-8 -*-
require 'formula'

class GitFlowCompletion < Formula
  url 'git://github.com/bobthecow/git-flow-completion.git', :tag => '0.4.0.2'
  version '0.4.0.2'
  head 'git://github.com/bobthecow/git-flow-completion.git', :branch => 'develop'

  def initialize
    # We need to hard-code the formula name since Homebrew can't
    # deduce it from the formula's filename, and the git download
    # strategy really needs a valid name.

    super "git-flow-completion"
  end

  homepage 'https://github.com/bobthecow/git-flow-completion'
end

class GitFlow < Formula
  url 'git://github.com/nvie/gitflow.git', :tag => '0.4.1'
  version '0.4.1'
  head 'git://github.com/nvie/gitflow.git', :branch => 'develop'

  homepage 'https://github.com/nvie/gitflow'

  def install
    system "make", "prefix=#{prefix}", "install"

    # Normally, etc files are installed directly into HOMEBREW_PREFIX,
    # rather than being linked from the Cellar — this is so that
    # configuration files don't get clobbered when you update.  The
    # bash-completion file isn't really configuration, though; it
    # should be updated when we upgrade the package.

    cellar_etc = prefix + 'etc'
    bash_completion_d = cellar_etc + "bash_completion.d"

    completion = GitFlowCompletion.new
    completion.brew do
      bash_completion_d.install "git-flow-completion.bash"
    end
  end
end
