require 'formula'

class Md5deep < Formula
  url 'http://downloads.sourceforge.net/project/md5deep/md5deep/md5deep-3.6/md5deep-3.6.tar.gz'
  homepage 'http://md5deep.sourceforge.net/'
  md5 '1042f66125537a9da7442c741c9e0f4e'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
