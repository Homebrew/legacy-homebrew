require 'formula'
require 'hardware'

class Pypy < Formula
  url 'https://bitbucket.org/pypy/pypy/downloads/pypy-1.8-osx64.tar.bz2'
  md5 '1c293253e8e4df411c3dd59dff82a663'
  version '1.8'
  homepage 'http://pypy.org/'

  def install
    prefix.install Dir['*']
  end
end
