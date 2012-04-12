require 'formula'

class Le < Formula
  url 'http://ftp.yar.ru/pub/source/le/le-1.14.5.tar.bz2'
  homepage 'http://directory.fsf.org/project/le-editor/'
  md5 '92d9ff5e0e91eba6b93d49d50070143c'

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
