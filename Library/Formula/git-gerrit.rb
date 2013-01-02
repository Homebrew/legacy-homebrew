require 'formula'

class GitGerrit < Formula
  homepage 'https://github.com/fbzhong/git-gerrit'
  url 'https://github.com/fbzhong/git-gerrit/tarball/v0.3.0'
  sha1 '51cf12de64ab67826fe14c2d9486c9675f5752f8'

  def install
    prefix.install 'bin'

    (prefix+'etc/bash_completion.d').install 'completion/git-gerrit-completion.bash'
  end
end
