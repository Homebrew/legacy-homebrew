require 'formula'

class Mathomatic < Formula
  url 'http://mathomatic.org/mathomatic-15.7.1.tar.bz2'
  homepage 'http://www.mathomatic.org/'
  md5 'f8144e9c17edf688cbb296d20efaf808'

  def install
    ENV['prefix'] = prefix
    system "make READLINE=1"
    system "make install"
  end
end
