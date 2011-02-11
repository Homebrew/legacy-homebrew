require 'formula'

class Recutils <Formula
  url 'http://ftp.gnu.org/gnu/recutils/recutils-1.2.tar.gz'
  homepage 'http://www.gnu.org/software/recutils/'
  md5 '4cd6244a129f7318c4ee4a7461ff9050'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
