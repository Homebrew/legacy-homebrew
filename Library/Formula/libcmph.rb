require 'formula'

class Libcmph <Formula
  url 'http://downloads.sourceforge.net/project/cmph/cmph/cmph-0.9/cmph-0.9.tar.gz'
  homepage 'http://cmph.sourceforge.net'
  md5 '14c17e3058174e9333936caa8e18ed28'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
