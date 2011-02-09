require 'formula'

class Ncftp <Formula
  homepage 'http://www.ncftp.com'
  url 'ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.gz'
  md5 '685e45f60ac11c89442c572c28af4228'

  def install
    system "./configure", "--disable-universal", "--disable-precomp",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
