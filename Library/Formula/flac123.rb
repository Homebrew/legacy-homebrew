class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "http://flac-tools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/flac-tools/flac123/0.0.11/flac123-0.0.11.tar.gz"
  sha256 "2f96da02c28730fcc2c71e9e6975268a4b01b0a298f1bea58a5543192f972b66"

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flac123"
  end
end
