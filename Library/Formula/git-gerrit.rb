require 'formula'

class GitGerrit < Formula
  url 'https://github.com/fbzhong/git-gerrit/tarball/v0.2.0'
  homepage 'https://github.com/fbzhong/git-gerrit'
  md5 '943163c38db55173bc9be981d03fbd8e'

  def install
    # install scripts in bin.
    bin.install Dir['bin/*']

    # install bash completions.
    (prefix + 'etc/bash_completion.d').install 'completion/git-gerrit-completion.bash'

  end

end
