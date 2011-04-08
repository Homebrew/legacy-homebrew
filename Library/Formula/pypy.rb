require 'formula'
require 'hardware'

class Pypy < Formula
  if MacOS.prefer_64_bit?
    url 'http://pypy.org/download/pypy-1.4.1-osx64.tar.bz2'
    md5 '769b3fb134944ee8c22ad0834970de3b'
  else
    url 'http://pypy.org/download/pypy-1.4.1-osx.tar.bz2'
    md5 '8584c4e8c042f5b661fcfffa0d9b8a25'
  end
  homepage 'http://pypy.org/'
  version '1.4.1'

  def install
    prefix.install ["bin", "lib-python", "lib_pypy"]
  end
end
