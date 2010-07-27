require 'formula'

class Libmms <Formula
  url 'http://launchpad.net/libmms/trunk/0.5/+download/libmms-0.5.tar.gz'
  homepage 'https://launchpad.net/libmms'
  md5 'cf83053ec891f14e73a04c84d9de08ee'

  depends_on 'pkg-config'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
