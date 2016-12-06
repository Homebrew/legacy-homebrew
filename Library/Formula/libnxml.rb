require 'formula'

class Libnxml < Formula
  homepage 'http://www.autistici.org/bakunin/libnxml/'
  url 'http://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz'
  md5 '857f43970e7f0724d28f4ddc87085daf'

  depends_on 'curl' unless MacOS.lion? # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
