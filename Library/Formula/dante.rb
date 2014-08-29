require "formula"

class Dante < Formula
  homepage "http://www.inet.no/dante/"
  url "http://www.inet.no/dante/files/dante-1.4.0.tar.gz"
  sha1 "3bb6978e3600f5117c54ab5f2b7307dddfd9bce8"

  bottle do
    cellar :any
    sha1 "b284bad2754b9c65df5750a90a5be7ceda4062df" => :mavericks
    sha1 "25d0199e64d429180f999507f98a87d9050d6d9b" => :mountain_lion
    sha1 "55c59f4650036ed6364740059f8f749976a535fe" => :lion
  end

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
