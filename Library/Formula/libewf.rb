require 'formula'

class Libewf < Formula
  homepage 'http://sourceforge.net/projects/libewf/'
  url 'http://downloads.sourceforge.net/project/libewf/libewf2/libewf-20120504/libewf-20120504.tar.gz'
  md5 '1b96b845476173353839ca72bca12097'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
