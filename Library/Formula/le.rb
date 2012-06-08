require 'formula'

class Le < Formula
  url 'http://ftp.yar.ru/pub/source/le/le-1.14.6.tar.bz2'
  homepage 'http://directory.fsf.org/project/le-editor/'
  md5 '1ec0496142b8be06dbc6139b87961140'

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
