require 'formula'

#
# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs
#

class Gpac <Formula
  url 'http://downloads.sourceforge.net/gpac/gpac-0.4.5.tar.gz'
  homepage 'http://gpac.sourceforge.net/index.php'
  md5 '755e8c438a48ebdb13525dd491f5b0d1'

  depends_on 'sdl' => :optional

  def install
    ENV.deparallelize
    system "chmod +x configure"
    system "./configure", "--disable-wx", "--use-ffmpeg=no",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
