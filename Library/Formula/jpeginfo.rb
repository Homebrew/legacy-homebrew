require 'formula'

class Jpeginfo < Formula
  homepage 'http://www.kokkonen.net/tjko/projects.html'
  url 'http://www.kokkonen.net/tjko/src/jpeginfo-1.6.1.tar.gz'
  sha1 '8fd998c3090908d1b100ed38d5d7fc2600e5742b'

  depends_on 'jpeg'

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/jpeginfo", "--help"
  end
end
