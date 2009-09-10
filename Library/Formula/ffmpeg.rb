require 'brewkit'

class Ffmpeg <Formula
  @head='svn://svn.ffmpeg.org/ffmpeg/trunk'
  @homepage='http://ffmpeg.org/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-nonfree", 
                          "arch=x86_64"
    system "make install"
  end
end
