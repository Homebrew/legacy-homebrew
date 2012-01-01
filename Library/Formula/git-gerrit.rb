require 'formula'

class GitGerrit < Formula
  url 'https://github.com/fbzhong/git-gerrit/tarball/v0.1.0'
  homepage 'https://github.com/fbzhong/git-gerrit'
  md5 '9c3bfc1fd59e789f0720e6abd3cf884c'

  def install
    # install scripts in bin.
    prefix.install 'bin'

    # install bash completions.
    cellar_etc = prefix + 'etc'
    bash_completion_d = cellar_etc + "bash_completion.d"
    bash_completion_d.install "completion/git-gerrit-completion.bash"

  end

end
