require 'brewkit'

class Ffmpeg <Formula
  @head='svn://svn.ffmpeg.org/ffmpeg/trunk'
  @homepage='http://ffmpeg.org/'
  depends_on 'x264'

  def install
    configure_flags = [ "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-nonfree",
                          "--enable-gpl",
                          "--enable-libx264"]
    configure_flags << "--arch=x64_64" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6
    system "./configure", *configure_flags
    system "make install"
  end
end
