require 'formula'

class GitGerrit < Formula
  homepage 'https://github.com/fbzhong/git-gerrit'
  url 'https://github.com/fbzhong/git-gerrit/archive/v0.3.0.tar.gz'
  sha1 '0e38e6f6657ff50d6692de9ce880d4698120325b'

  def install
    prefix.install 'bin'

    (prefix+'etc/bash_completion.d').install 'completion/git-gerrit-completion.bash'
  end
end
