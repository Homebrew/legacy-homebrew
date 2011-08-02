require 'formula'

class FfmpegPhp < Formula
  homepage 'http://ffmpeg-php.sourceforge.net'
  head 'http://ffmpeg-php.svn.sourceforge.net/svnroot/ffmpeg-php/trunk/ffmpeg-php'

  depends_on 'ffmpeg'

  def install
    system "phpize"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ffmpeg=#{HOMEBREW_PREFIX}"
    system "make"
    prefix.install 'modules/ffmpeg.so'
  end

  def caveats; <<-EOS
 * Add the following line to php.ini:
    extension="#{prefix}/ffmpeg.so"
 * Restart your webserver.
 * Write a PHP page that calls "phpinfo();"
 * Load it in a browser and look for the info on the ffmpeg module.
 * If you see it, you have been successful!
    EOS
  end
end
