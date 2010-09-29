require 'formula'

class Mongrel2 <Formula
  url 'http://mongrel2.org/static/downloads/mongrel2-1.2.tar.bz2'
  homepage 'http://mongrel2.org/'
  md5 'ef3b171ba9f8a06f998105a7ff1adee5'

  depends_on 'zeromq'

  def install
    system "make all"
    system "make install PREFIX=#{prefix}"
  end
end
