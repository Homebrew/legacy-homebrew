require 'formula'

class Md5deep < Formula
  homepage 'http://md5deep.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/md5deep/md5deep/md5deep-4.1/md5deep-4.1.tar.gz'
  md5 'bc439546ba093286ac20f699bace6f58'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
