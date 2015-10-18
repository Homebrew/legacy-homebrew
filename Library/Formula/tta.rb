class Tta < Formula
  desc "TTA lossless audio codec"
  homepage "http://www.true-audio.com"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-2.2.tar.gz"
  sha256 "1723424d75b3cda907ff68abf727bb9bc0c23982ea8f91ed1cc045804c1435c4"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-sse4"
    system "make", "install"
  end
end
