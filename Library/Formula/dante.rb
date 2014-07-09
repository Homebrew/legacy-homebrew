require "formula"

class Dante < Formula
  homepage "http://www.inet.no/dante/"
  url "http://www.inet.no/dante/files/dante-1.4.0.tar.gz"
  sha1 "3bb6978e3600f5117c54ab5f2b7307dddfd9bce8"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/socksify"
  end
end
