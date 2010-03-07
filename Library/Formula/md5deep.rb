require 'formula'

class Md5deep <Formula
  url 'http://sourceforge.net/projects/md5deep/files/md5deep/md5deep-3.5.1/md5deep-3.5.1.tar.gz'
  homepage 'http://md5deep.sourceforge.net/'
  md5 'c568d1193e83d0a76b501396abca2be7'
  version '3.5.1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
