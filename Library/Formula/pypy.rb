require 'formula'
require 'hardware'

class Pypy < Formula
  if MacOS.prefer_64_bit?
    url 'http://bitbucket.org/pypy/pypy/downloads/pypy-1.6-osx64.tar.bz2'
    md5 '78bbf70f55e9fec20d7ac22531a997fc'
    version '1.6.0'
  else
    url 'http://pypy.org/download/pypy-1.4.1-osx.tar.bz2'
    md5 '8584c4e8c042f5b661fcfffa0d9b8a25'
    version '1.4.1'
  end
  homepage 'http://pypy.org/'

  def install
    prefix.install Dir['*']
  end
end
