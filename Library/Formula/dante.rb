require "formula"

class Dante < Formula
  homepage "http://www.inet.no/dante/"
  url "http://www.inet.no/dante/files/dante-1.4.1.tar.gz"
  mirror "ftp://ftp.inet.no/pub/socks/dante-1.4.1.tar.gz"
  sha1 "17ded4322d78b7b031da23cd4e03dbb14f397d71"

  depends_on "miniupnpc" => :optional

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
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system "#{sbin}/sockd", "-v"
  end
end
