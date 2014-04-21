require 'formula'

class LibvoAacenc < Formula
  homepage 'http://opencore-amr.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/opencore-amr/vo-aacenc/vo-aacenc-0.1.2.tar.gz'
  sha1 'ac56325c05eba4c4f8fe2c5443121753f4d70255'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
