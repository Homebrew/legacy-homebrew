require 'formula'

class Flac123 < Formula
  homepage 'http://flac-tools.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/flac-tools/flac123/0.0.11/flac123-0.0.11.tar.gz'
  sha1 'a713097bb55e4c9998df32a0a33042f8a79bc6d4'

  depends_on 'flac'
  depends_on 'libao'
  depends_on 'libogg'
  depends_on 'popt'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flac123"
  end
end
