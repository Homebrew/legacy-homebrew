require 'formula'

class Smartmontools <Formula
  version '5.40'
  url "http://downloads.sourceforge.net/project/smartmontools/smartmontools/#{@version}/smartmontools-#{@version}.tar.gz"
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  md5 '0f0be0239914ad87830a4fff594bda5b'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
