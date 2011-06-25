require 'formula'

class Htmlcxx < Formula
  url 'http://downloads.sourceforge.net/project/htmlcxx/htmlcxx/0.84/htmlcxx-0.84.tar.gz'
  homepage 'http://htmlcxx.sourceforge.net/'
  md5 'd2e0e6f4c509ef1809d90dd21c3ba3e8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
