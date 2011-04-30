require 'formula'
require 'hardware'

class Pypy < Formula
  url 'http://pypy.org/download/pypy-1.5-osx64.tar.bz2'
  md5 'b1417916bc01ebb9f95c666f5e397fb5'
  homepage 'http://pypy.org/'
  version '1.5.0'

  def install
    prefix.install ["bin", "lib-python", "lib_pypy"]
  end
end
