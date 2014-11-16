require 'formula'

class GitFlowClone < Formula
  homepage 'https://github.com/ashirazi/git-flow-clone'
  url 'https://github.com/ashirazi/git-flow-clone/archive/0.1.2.tar.gz'
  sha1 'd4d5c106ebd7de8abbee69f0b277ecdfe85e5b6d'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    Either git-flow or git-flow-avh (recommended) need to be installed:
      brew install git-flow
    or:
      brew install git-flow-avh

    If installed with git-flow-avh update ~/.gitflow_export with:
      export GITFLOW_DIR=#{HOMEBREW_PREFIX}/bin
    EOS
  end
end
