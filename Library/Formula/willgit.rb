require 'formula'

class Willgit <Formula
  head 'git://gitorious.org/willgit/mainline.git'
  homepage 'http://git-wt-commit.rubyforge.org/'

  def install
    Dir.chdir 'bin' do
      bin.install %w[git-publish-branch git-rank-contributors git-show-merges git-wtf]
    end
  end
end
