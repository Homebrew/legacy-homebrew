require 'formula'

class Mongrel2 <Formula
  url 'http://mongrel2.org/static/downloads/mongrel2-1.4.tar.bz2'
  head 'fossil://http://mongrel2.org:44445/'
  homepage 'http://mongrel2.org/'
  md5 'd5b917c7cb2fd0527f6824edda37cefb'

  depends_on 'zeromq'

  def install
    system "make all"
    system "make install PREFIX=#{prefix}"
  end
end
