require 'formula'

class Ninja <Formula
  head 'git://github.com/alexgartrell/ninja.git'
  homepage 'https://github.com/martine/ninja'
  md5 ''

  def install
    system "./bootstrap.sh"
    bin.mkpath
    bin.install "ninha"
  end
end
