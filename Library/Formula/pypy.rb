require 'formula'

class Pypy <Formula
  url 'http://pypy.org/download/pypy-1.2-osx.tar.bz2'
  homepage 'http://pypy.org/'
  md5 'b5f693d7add487c5c5c16c0603fc1e5f'
  version '1.2'

  def install
    prefix.install 'bin'
    # See: http://pypy.org/download.html#installing
    (share+"pypy-#{version}").install ["lib-python", "pypy"]
  end
end
