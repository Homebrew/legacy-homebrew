require 'formula'

class Mathomatic <Formula
  url 'http://launchpad.net/mathomatic/15/15.0.6/+download/mathomatic-15.0.6.tar.bz2'
  homepage 'http://www.mathomatic.org/'
  md5 '4674deb2afde1b34f7ff8cb481596328'


  def install
    ENV['prefix'] = "#{prefix}"
    system "make"
    system "make install"
  end
end
