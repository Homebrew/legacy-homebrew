require 'formula'

class Mathomatic <Formula
  url 'http://mathomatic.org/mathomatic-15.4.1.tar.bz2'
  homepage 'http://www.mathomatic.org/'
  md5 'c7bdb3c23db39f39d97d8c8eb137f8a6'

  def install
    ENV['prefix'] = prefix
    system "make READLINE=1"
    system "make install"
  end
end
