require 'formula'

class GitFlowAvhCompletion < Formula
  homepage 'https://github.com/petervanderdoes/git-flow-completion'
  url 'https://github.com/petervanderdoes/git-flow-completion/archive/0.4.2.tar.gz'
  sha1 '5e311225fccc22e22c7f00abf8989c853bd2b48b'

  head 'https://github.com/petervanderdoes/git-flow-completion.git', :branch => 'develop'
end

class GitFlowAvh < Formula
  homepage 'https://github.com/petervanderdoes/gitflow'
  url 'https://github.com/petervanderdoes/gitflow/archive/1.5.1.tar.gz'
  sha1 'bb984d36ce1c89fc07877d9a3ebd3540633efd9a'

  head 'https://github.com/petervanderdoes/gitflow.git', :branch => 'develop'

  depends_on 'gnu-getopt'

  conflicts_with 'git-flow'

  def install
    system "make", "prefix=#{prefix}", "install"

    GitFlowAvhCompletion.new('git-flow-avh-completion').brew do
      (prefix+'etc/bash_completion.d').install "git-flow-completion.bash"
      (share+'zsh/site-functions').install "git-flow-completion.zsh"
    end
  end

  def caveats; <<-EOS.undent
    Create a ~/.gitflow_export file with the content
      export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"
     EOS
  end

  def test
    system "#{bin}/git-flow version"
  end
end
