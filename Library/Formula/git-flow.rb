require 'formula'

class GitFlowCompletion < Formula
  homepage 'https://github.com/bobthecow/git-flow-completion'
  url 'https://github.com/bobthecow/git-flow-completion/tarball/0.4.1.0'
  sha1 'c3d09e9d9e6a268d0587e31d30d6a20ca8c36800'

  head 'https://github.com/bobthecow/git-flow-completion.git', :branch => 'develop'
end

class GitFlow < Formula
  homepage 'https://github.com/nvie/gitflow'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/nvie/gitflow.git', :tag => '0.4.1'
  version '0.4.1'

  head 'https://github.com/nvie/gitflow.git', :branch => 'develop'

  def install
    system "make", "prefix=#{prefix}", "install"

    GitFlowCompletion.new('git-flow-completion').brew do
      (prefix+'etc/bash_completion.d').install "git-flow-completion.bash"
      (share+'zsh/site-functions').install "git-flow-completion.zsh"
    end
  end
end
