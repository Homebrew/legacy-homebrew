require 'formula'

class Pypy <Formula
  url 'http://pypy.org/download/pypy-1.3-osx.tar.bz2'
  homepage 'http://pypy.org/'
  md5 'eb34325767bef243dc642252ffb1005a'
  version '1.3'

  def install
    prefix.install 'bin'
    # See: http://pypy.org/download.html#installing
    (share+"pypy-#{version}").install ["lib-python", "pypy"]
  end
end
