require 'brewkit'

class Monit <Formula
  url 'http://mmonit.com/monit/dist/monit-5.0.3.tar.gz'
  homepage 'http://mmonit.com/monit/'
  md5 'dae7859ec10551fc941daeae60dee9d3'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
