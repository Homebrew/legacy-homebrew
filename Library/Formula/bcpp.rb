require 'formula'

class Bcpp <Formula
  url 'ftp://invisible-island.net/bcpp/bcpp-20090630.tgz'
  homepage 'http://invisible-island.net/bcpp/'
  md5 '3428176dafcf4af1d2741804bca05189'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
