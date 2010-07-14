require 'formula'

class Mathomatic <Formula
  url 'http://launchpad.net/mathomatic/15/15.0.8/+download/mathomatic-15.0.8.tar.bz2'
  homepage 'http://www.mathomatic.org/'
  md5 '24f8c4f80318215f2190daefc1f0e106'


  def install
    ENV['prefix'] = "#{prefix}"
    system "make READLINE=1"
    system "make install"
  end
end
