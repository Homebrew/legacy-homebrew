require "formula"

class Synscan < Formula
  desc "Asynchronous half-open TCP portscanner"
  homepage "http://www.digit-labs.org/files/tools/synscan/"
  url "http://www.digit-labs.org/files/tools/synscan/releases/synscan-5.02.tar.gz"
  sha1 "fd2461a9520204682228f942cce075782e0fc21c"

  bottle do
    cellar :any
    sha1 "e09f75a92648543f7b716b1fe032aa7c0e392a2f" => :yosemite
    sha1 "1f20a172f16c90c75ed182bc69aa11f2008984ae" => :mavericks
    sha1 "126a969ae17f84535a71333ba1372caca7efabd5" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "macos"
    system "make", "install"
  end

  test do
    system "#{bin}/synscan", "-V"
  end
end
