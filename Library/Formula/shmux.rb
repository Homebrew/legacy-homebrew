require 'formula'

class Shmux < Formula
  homepage 'http://web.taranis.org/shmux/'
  url 'http://web.taranis.org/shmux/dist/shmux-1.0.2.tgz'
  sha1 '6fe39602c497331e448c4331b8cddbb2abb71b79'


  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
