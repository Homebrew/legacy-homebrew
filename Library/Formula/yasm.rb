require 'brewkit'

class Yasm <Formula
  @url='http://www.tortall.net/projects/yasm/releases/yasm-0.8.0.tar.gz'
  @homepage='http://www.tortall.net/projects/yasm/'
  @md5='84a72204c9b452a00b39b1b00495163f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
