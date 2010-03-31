require 'formula'

class Poppler <Formula
  url 'http://poppler.freedesktop.org/poppler-0.12.4.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '4155346f9369b192569ce9184ff73e43'

  depends_on 'pkg-config'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
