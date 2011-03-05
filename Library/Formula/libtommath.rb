require 'formula'

class Libtommath < Formula
  url 'http://libtom.org/files/ltm-0.42.0.tar.bz2'
  homepage 'http://libtom.org/?page=features&newsitems=5&whatfile=ltm'
  md5 '7380da904b020301be7045cb3a89039b'

  def install
    system "make DESTDIR=#{prefix} LIBPATH=/lib INCPATH=/include"
    system "make install DESTDIR=#{prefix} LIBPATH=/lib INCPATH=/include"
  end
end
