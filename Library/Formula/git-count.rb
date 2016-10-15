require 'formula'

class GitCount < Formula
  homepage 'https://github.com/neethouse/git-count'
  url 'https://github.com/neethouse/git-count.git', :tag => '1.0.0'

  head 'https://github.com/neethouse/git-count.git', :branch => 'master'

  def install
    bin.install('git-count')
  end

end

