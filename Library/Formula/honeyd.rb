require 'formula'

class Honeyd < Formula
  homepage 'http://honeyd.org/'
  url 'http://www.honeyd.org/uploads/honeyd-1.5c.tar.gz'
  sha1 '342cc53e8d23c84ecb91c7b66c6e93e7ed2a992a'

  depends_on 'libdnet'
  depends_on 'libevent1'

  def install
    system "./configure --prefix=#{prefix} --with-libevent=#{Formula.factory('libevent1').prefix}"
    system 'make install'
  end
end
