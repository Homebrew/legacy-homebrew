require 'formula'
require 'hardware'

class Pypy < Formula
  if MacOS.prefer_64_bit?
    url 'https://bitbucket.org/pypy/pypy/downloads/pypy-1.7-osx64.tar.bz2'
    md5 'ff979054fc8e17b4973ffebb9844b159'
    version '1.7'
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
