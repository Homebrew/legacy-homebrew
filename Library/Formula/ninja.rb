require 'formula'

class Ninja <Formula
  head 'git://github.com/alexgartrell/ninja.git'
  homepage 'https://github.com/martine/ninja'
  md5 ''

  def install
    system "./bootstrap.sh"
    system "mkdir -p #{prefix}/bin ; cp ninja #{prefix}/bin/ninja"
  end
end
