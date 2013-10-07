require 'formula'

class Flac123 < Formula
  homepage 'http://flac-tools.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/flac-tools/flac123/0.0.11/flac123-0.0.11.tar.gz?r=http%3A%2F%2Fflac-t
  sha1 'a713097bb55e4c9998df32a0a33042f8a79bc6d4'

  depends_on 'popt' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "flac123"
  end
end
