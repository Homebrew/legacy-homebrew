require "formula"

class Synscan < Formula
  homepage "http://www.digit-labs.org/files/tools/synscan/"
  url "http://www.digit-labs.org/files/tools/synscan/releases/synscan-5.02.tar.gz"
  sha1 "fd2461a9520204682228f942cce075782e0fc21c"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "macos"
    system "make", "install"
  end

  test do
    system "#{bin}/synscan", "-V"
  end
end
