require 'formula'

class Leafnode < Formula
  homepage 'http://sourceforge.net/projects/leafnode/'
  url 'http://downloads.sourceforge.net/project/leafnode/leafnode/1.11.8/leafnode-1.11.8.tar.bz2'
  sha1 '25bd5de560ffa3bd3adf5a7c7108fe517c3e4cde'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
