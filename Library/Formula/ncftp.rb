require 'brewkit'

class Ncftp <Formula
  @homepage='http://www.ncftp.com'
  @url='ftp://ftp.ncftp.com/ncftp/ncftp-3.2.3-src.tar.gz'
  @md5='f08238032ab247aa78f935edfc4db9fb'

  def install
    system "./configure --disable-universal --disable-precomp --prefix='#{prefix}'"
    system "make"
    system "make install"
  end
end