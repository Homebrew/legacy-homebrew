require 'formula'

class GitGerrit < Formula
  homepage 'https://github.com/fbzhong/git-gerrit'
  url 'https://github.com/fbzhong/git-gerrit/tarball/v0.3.0'
  md5 '3289ad86d22c3422701361a639d67573'

  def install
    prefix.install 'bin'

    (prefix+'etc/bash_completion.d').install 'completion/git-gerrit-completion.bash'
  end
end
