require 'formula'

class Tnef < Formula
  homepage 'http://sourceforge.net/projects/tnef/'
  url 'http://downloads.sourceforge.net/project/tnef/tnef/tnef-1.4.8.tar.gz'
  md5 'cc6443ac5f30913394c0c16ae7941e4f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
