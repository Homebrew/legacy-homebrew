require 'formula'

class Xmp < Formula
  url 'http://downloads.sourceforge.net/project/xmp/xmp/3.5.0/xmp-3.5.0.tar.gz'
  homepage 'http://xmp.sourceforge.net'
  md5 '47e54e6dfa88ce37370054d4a3ea955f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # install the included demo song
    share.install "SynthSong1"
  end

  def test
    system "#{bin}/xmp --load-only #{share}/SynthSong1"
  end
end
