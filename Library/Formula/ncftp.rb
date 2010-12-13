require 'formula'

class Ncftp <Formula
  homepage 'http://www.ncftp.com'
  url 'ftp://ftp.ncftp.com/ncftp/ncftp-3.2.4-src.tar.gz'
  md5 '418f3e660d33c8ae98e8a3dd80fb4e1c'

  def install
    system "./configure", "--disable-universal", "--disable-precomp",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
