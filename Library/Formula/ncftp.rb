require 'formula'

class Ncftp <Formula
  homepage 'http://www.ncftp.com'
  url 'ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.gz'
  md5 'cbcc1eb766e5798e31257abd8f52823b'

  def install
    system "./configure", "--disable-universal", "--disable-precomp",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
