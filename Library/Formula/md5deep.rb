require 'formula'

class Md5deep < Formula
  url 'http://downloads.sourceforge.net/project/md5deep/md5deep/md5deep-4.0.0/md5deep-4.0.0.tar.gz'
  homepage 'http://md5deep.sourceforge.net/'
  md5 'fc3c0afbcf72861a5a42c699e804d6d4'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
