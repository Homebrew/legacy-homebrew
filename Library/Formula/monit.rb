require 'formula'

class Monit <Formula
  url 'http://mmonit.com/monit/dist/monit-5.1.1.tar.gz'
  homepage 'http://mmonit.com/monit/'
  md5 '4bbd3845ae1cbab13ec211824e0486dc'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
