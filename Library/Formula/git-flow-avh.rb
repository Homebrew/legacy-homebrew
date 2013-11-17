require 'formula'

class GitFlowAvh < Formula
  homepage 'https://github.com/petervanderdoes/gitflow'
  url 'https://github.com/petervanderdoes/gitflow/archive/1.7.0.tar.gz'
  sha1 '666b01444de2e1b628f83fe1c8b5481b24156502'

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
    system "make", "prefix=#{prefix}", "install"

    resource('completion').stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
    end
  end

  def caveats; <<-EOS.undent
    Create a ~/.gitflow_export file with the content
      export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"
     EOS
  end

  test do
    system "#{bin}/git-flow", "version"
  end
end
