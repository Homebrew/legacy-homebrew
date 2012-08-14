require 'formula'

class Leafnode < Formula
  homepage 'http://sourceforge.net/projects/leafnode/'
  url 'http://downloads.sourceforge.net/project/leafnode/leafnode/1.11.8/leafnode-1.11.8.tar.bz2'
  md5 'a3edafeb854efaa3fbb0f7951d02160f'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
