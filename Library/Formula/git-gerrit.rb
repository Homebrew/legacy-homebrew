require 'formula'

class GitGerrit < Formula
  url 'https://github.com/fbzhong/git-gerrit/tarball/v0.3.0'
  homepage 'https://github.com/fbzhong/git-gerrit'
  md5 '3289ad86d22c3422701361a639d67573'

  def install
    prefix.install 'bin'

    # install bash completions.
    (prefix + 'etc/bash_completion.d').install 'completion/git-gerrit-completion.bash'
  end
end
