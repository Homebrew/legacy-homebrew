require 'formula'

class GitFlowCompletion < Formula
  homepage 'https://github.com/bobthecow/git-flow-completion'
  url 'https://github.com/bobthecow/git-flow-completion.git', :tag => '0.4.1.0'
  version '0.4.1.0'

  head 'https://github.com/bobthecow/git-flow-completion.git', :branch => 'develop'

  def initialize
    # We need to hard-code the formula name since Homebrew can't
    # deduce it from the formula's filename, and the git download
    # strategy really needs a valid name.
    super "git-flow-completion"
  end
end

class GitFlow < Formula
  homepage 'https://github.com/nvie/gitflow'
  url 'https://github.com/nvie/gitflow.git', :tag => '0.4.1'
  version '0.4.1'

  head 'https://github.com/nvie/gitflow.git', :branch => 'develop'

  def install
    system "make", "prefix=#{prefix}", "install"

    GitFlowCompletion.new.brew do
      (prefix+'etc/bash_completion.d').install "git-flow-completion.bash"
    end
  end
end
