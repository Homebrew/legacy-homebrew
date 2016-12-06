require 'formula'

class Bindfs < Formula
  url 'http://bindfs.googlecode.com/files/bindfs-1.9.tar.gz'
  homepage 'http://code.google.com/p/bindfs/'
  md5 '610778ad89bc5b0ff0be7b44bb2b6f0c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/bindfs --version"
  end
end
