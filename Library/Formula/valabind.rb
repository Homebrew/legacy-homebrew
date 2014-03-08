require 'formula'

class Valabind < Formula
  homepage 'http://radare.org/'
  url 'https://github.com/radare/valabind/archive/0.8.0.tar.gz'
  sha1 'f677110477e14c2e18ac61c56730ab0e51ac450d'

  head 'https://github.com/radare/valabind.git'

  depends_on 'pkg-config' => :build
  depends_on 'swig' => :run
  depends_on 'vala'

  def install
    system 'make'
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
