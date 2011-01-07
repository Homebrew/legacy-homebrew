require 'formula'

class Smartmontools <Formula
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/5.39.1/smartmontools-5.39.1.tar.gz'
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  md5 'f6f7380ae45587161c0adae8862110e9'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
