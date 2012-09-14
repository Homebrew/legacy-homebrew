require 'formula'

class Mp3fs < Formula
  homepage 'http://khenriks.github.com/mp3fs/'
  url 'https://github.com/downloads/khenriks/mp3fs/mp3fs-0.32.tar.gz'
  sha1 'e6aef12f753721c87bdecfb4dca7e3721a808828'

  depends_on 'pkg-config' => :build
  depends_on 'lame'
  depends_on 'fuse4x'
  depends_on 'libid3tag'
  depends_on 'flac'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/mp3fs -V | grep MP3FS && true || false"
  end
end
