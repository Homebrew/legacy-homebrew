require 'formula'

class Mongrel2 <Formula
  url 'http://mongrel2.org/static/downloads/mongrel2-1.3.tar.bz2'
  head 'fossil://http://mongrel2.org:44445/'
  homepage 'http://mongrel2.org/'
  md5 'dfc19b26e93d707c68fcff2d72a0d03f'

  depends_on 'zeromq'

  def install
    system "make all"
    system "make install PREFIX=#{prefix}"
  end
end
