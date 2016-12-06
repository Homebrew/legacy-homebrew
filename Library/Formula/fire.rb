require 'formula'

class Fire <Formula
  head 'git://github.com/AzizLight/fire.git'
  homepage 'http://github.com/AzizLight/fire'

  def install
    bin.install "fire"
  end
end
