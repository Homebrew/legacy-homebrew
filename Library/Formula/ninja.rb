require 'formula'

class Ninja <Formula
  head 'git://github.com/alexgartrell/ninja.git'
  homepage 'https://github.com/martine/ninja'

  def install
    system "./bootstrap.sh"
    bin.mkpath
    bin.install "ninja"
  end
end
