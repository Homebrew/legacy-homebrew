require 'formula'

class GitFlow < Formula
  homepage 'https://github.com/nvie/gitflow'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/nvie/gitflow.git', :tag => '0.4.1'

  head do
    url 'https://github.com/nvie/gitflow.git', :branch => 'develop'

    resource 'completion' do
      url 'https://github.com/bobthecow/git-flow-completion.git', :branch => 'develop'
    end
  end

  resource 'completion' do
    url 'https://github.com/bobthecow/git-flow-completion/archive/0.4.2.2.tar.gz'
    sha1 'd6a041b22ebdfad40efd3dedafd84c020d3f4cb4'
  end

  conflicts_with 'git-flow-avh'

  def install
    system "make", "prefix=#{libexec}", "install"
    bin.write_exec_script libexec/'bin/git-flow'

    resource('completion').stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
    end
  end
end
