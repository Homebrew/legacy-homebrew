require 'formula'

class Moc < Formula
  homepage 'http://moc.daper.net/'
  url 'ftp://ftp.daper.net/pub/soft/moc/unstable/moc-2.5.0-beta1.tar.bz2'
  version '2.5.0-beta1'
  sha1 '4030a1fa5c7cfef06909c54d8c7a1fbb93f23caa'

  depends_on 'flac'
  depends_on 'jack'
  depends_on 'libid3tag'
  depends_on 'libmad'
  depends_on 'libvorbis'
  depends_on 'ffmpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
