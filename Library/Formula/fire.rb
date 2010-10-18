require 'formula'

class Fire <Formula
  head 'http://bitbucket.org/azizlight/fire', :using => :hg
  homepage 'http://bitbucket.org/azizlight/fire/src'

  def install
    bin.install "fire"
  end
end
