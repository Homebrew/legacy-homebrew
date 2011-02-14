require 'formula'

class Smartmontools <Formula
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/5.40/smartmontools-5.40.tar.gz'
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  md5 '0f0be0239914ad87830a4fff594bda5b'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
