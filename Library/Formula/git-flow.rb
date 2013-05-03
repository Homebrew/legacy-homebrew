require 'formula'

class GitFlowCompletion < Formula
  homepage 'https://github.com/bobthecow/git-flow-completion'
  url 'https://github.com/bobthecow/git-flow-completion/archive/0.4.2.tar.gz'
  sha1 '5e311225fccc22e22c7f00abf8989c853bd2b48b'

  head 'https://github.com/bobthecow/git-flow-completion.git', :branch => 'develop'
end

class GitFlow < Formula
  homepage 'https://github.com/nvie/gitflow'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/nvie/gitflow.git', :tag => '0.4.1'
  version '0.4.1'

  head 'https://github.com/nvie/gitflow.git', :branch => 'develop'

  conflicts_with 'git-flow-avh'

  def install
    system "make", "prefix=#{prefix}", "install"

    GitFlowCompletion.new('git-flow-completion').brew do
      (prefix+'etc/bash_completion.d').install "git-flow-completion.bash"
      (share+'zsh/site-functions').install "git-flow-completion.zsh"
    end
  end
end
