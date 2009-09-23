require 'brewkit'

class Libunistring <Formula
  @url='http://www.de-mirrors.de/gnuftp/libunistring/libunistring-0.9.1.1.tar.gz'
  @homepage='http://www.gnu.org/software/libunistring/'
  @md5='f8bdb65eaf1746bc6b659fb65c5ac685'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
