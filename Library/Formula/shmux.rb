require 'formula'

class Shmux < Formula
  url 'http://web.taranis.org/shmux/dist/shmux-1.0.2.tgz'
  homepage 'http://web.taranis.org/shmux/'
  md5 '4ab5c46b4154cbeab54bdc0036bd9140'


  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
