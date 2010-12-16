require 'formula'
require 'hardware'

class Pypy <Formula
  if snow_leopard_64?
    url 'http://pypy.org/download/pypy-1.4-osx64.tar.bz2'
    md5 '23ed155d7a8a214c61efc9000d559383'
  else
    url 'http://pypy.org/download/pypy-1.4-osx.tar.bz2'
    md5 'b715229d2a2b4c7129f7867fd84e7caf'
  end
  homepage 'http://pypy.org/'
  version '1.4'

  def install
    prefix.install ["bin", "lib-python", "lib_pypy"]
  end
end
