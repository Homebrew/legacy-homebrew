require 'formula'

class GitCount < Formula

  homepage 'https://github.com/neethouse/git-count'
  url 'https://github.com/neethouse/git-count/archive/1.1.0.tar.gz'
  sha1 '0a6581a2dc5ea1f04f3937d0ba5b71a8c4335be7'

  def install
    bin.install 'git-count'
  end

end

