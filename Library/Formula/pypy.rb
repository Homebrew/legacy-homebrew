require 'formula'
require 'hardware'

class Pypy < Formula
  if MacOS.prefer_64_bit?
    url 'http://pypy.org/download/pypy-1.5-osx64.tar.bz2'
    md5 'b1417916bc01ebb9f95c666f5e397fb5'
    version '1.5.0'
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
