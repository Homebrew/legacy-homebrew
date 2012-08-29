require 'formula'

class Exif < Formula
  homepage 'http://libexif.sourceforge.net/'
  url 'http://sourceforge.net/projects/libexif/files/exif/0.6.21/exif-0.6.21.tar.gz'
  sha1 'd23139d26226b70c66d035bbc64482792c9f1101'

  depends_on 'pkg-config' => :build
  depends_on 'popt'
  depends_on 'libexif'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
