require 'brewkit'

class Findutils <Formula
  @url='http://ftp.gnu.org/pub/gnu/findutils/findutils-4.4.2.tar.gz'
  @homepage='http://www.gnu.org/software/findutils/'
  @md5='351cc4adb07d54877fa15f75fb77d39f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
