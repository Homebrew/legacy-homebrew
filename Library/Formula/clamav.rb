require 'formula'

class Clamav <Formula
  url 'http://downloads.sourceforge.net/project/clamav/clamav/0.96.2/clamav-0.96.2.tar.gz'
  homepage 'http://www.clamav.net/'
  md5 'a2c2555d86868f91a01d0e2c2403bbec'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
