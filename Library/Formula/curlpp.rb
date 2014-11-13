require "formula"

class Curlpp < Formula
  homepage "http://www.curlpp.org"
  url "https://curlpp.googlecode.com/files/curlpp-0.7.3.tar.gz"
  sha1 "f3c09b29917a055523a84a6fe2c30f7eb04da6b0"

  depends_on "boost"
  depends_on "curl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
      system "curlpp-config", "--version"
  end

end
