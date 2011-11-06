require 'formula'

class FastStatisticalAlignment < Formula
  url 'http://downloads.sourceforge.net/project/fsa/fsa-1.15.3.tar.gz'
  homepage 'http://fsa.sourceforge.net/'
  md5 '9c03a6b48c3a276f6233dc5715ed3d0a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
