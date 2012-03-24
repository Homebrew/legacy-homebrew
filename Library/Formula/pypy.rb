require 'formula'

class Pypy < Formula
  homepage 'http://pypy.org/'

  if MacOS.prefer_64_bit?
    url 'https://bitbucket.org/pypy/pypy/downloads/pypy-1.8-osx64.tar.bz2'
    version '1.8'
    md5 '1c293253e8e4df411c3dd59dff82a663'
  else
    url 'http://pypy.org/download/pypy-1.4.1-osx.tar.bz2'
    md5 '8584c4e8c042f5b661fcfffa0d9b8a25'
  end

  def install
    prefix.install Dir['*']
  end
end
