require 'formula'

class NewickUtils < Formula
  url 'http://cegg.unige.ch/pub/newick-utils-1.5.0.tar.gz'
  homepage 'http://cegg.unige.ch/newick_utils'
  md5 '5f65b0fe30bf9389297616358f01fac7'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "echo '(A:1,B:2);' | nw_display -"
  end
end
