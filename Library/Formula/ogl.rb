class Ogl < Formula
  desc "this is a test"
  homepage "http://www.khronos.org"
  url "https://github.com/cbeck88/test_gl/archive/v0.tar.gz"
  sha256 "6ff237be51dfa5a652e1abd349c80bde4a0c7d6b76077f498933283a963281f4"

  head "https://github.com/cbeck88/test_gl.git"

  def install
    system "./build.sh"
    bin.install "test"
  end

  test do
    system "#{bin}/test"
  end
end
