require 'formula'

class Mathomatic <Formula
  url 'http://mathomatic.org/mathomatic-15.3.5.tar.bz2'
  homepage 'http://www.mathomatic.org/'
  md5 'f348acc2982eb6becbbc52b9883acb99'

  def install
    ENV['prefix'] = prefix
    system "make READLINE=1"
    system "make install"
  end
end
