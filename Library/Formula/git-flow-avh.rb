require 'formula'

class GitFlowAvh < Formula
  homepage 'https://github.com/petervanderdoes/gitflow'
  url "https://github.com/petervanderdoes/gitflow/archive/1.8.0.tar.gz"
  sha1 "4bfdd7e83509f9464a867642bb5b3185d4cfcfdc"

  head do
    url 'https://github.com/petervanderdoes/gitflow.git', :branch => 'develop'

    resource 'completion' do
      url 'https://github.com/petervanderdoes/git-flow-completion.git', :branch => 'develop'
    end
  end

  resource 'completion' do
    url 'https://github.com/petervanderdoes/git-flow-completion/archive/0.5.1.tar.gz'
    sha1 'e29b79629323dc9a10e7b8ddca1ec00d51f62929'
  end

  depends_on 'gnu-getopt'

  conflicts_with 'git-flow'

  def install
    system "make", "prefix=#{libexec}", "install"
    (bin/'git-flow').write <<-EOS.undent
      #!/bin/bash
      export FLAGS_GETOPT_CMD=#{HOMEBREW_PREFIX}/opt/gnu-getopt/bin/getopt
      exec "#{libexec}/bin/git-flow" "$@"
    EOS

    resource('completion').stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
    end
  end

  test do
    system "#{bin}/git-flow", "version"
  end
end
