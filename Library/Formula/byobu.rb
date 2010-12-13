require 'formula'

class Byobu <Formula
  url 'http://launchpad.net/byobu/trunk/3.4/+download/byobu_3.4.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 '694c1663f178517b995ec9ca574fc463'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
