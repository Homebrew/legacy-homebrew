require 'brewkit'

class Pcre <Formula
  @url='ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-7.9.tar.bz2'
  @homepage='http://www.pcre.org/'
  @md5='b6a9669d1863423f01ea46cdf00f93dc'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
