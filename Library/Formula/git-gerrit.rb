require 'formula'

class GitGerrit < Formula
  url 'https://github.com/fbzhong/git-gerrit/tarball/v0.1.0'
  homepage 'https://github.com/fbzhong/git-gerrit'
  md5 '9c3bfc1fd59e789f0720e6abd3cf884c'

  def install
    # install scripts in bin.
    bin.install Dir['bin/*']

    # install bash completions.
    (prefix + 'etc/bash_completion.d').install 'completion/git-gerrit-completion.bash'

  end

end
