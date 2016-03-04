class Ogl < Formula
  desc "this is a test"
  homepage "http://www.khronos.org"
  url "http://www.khronos.org"
  version "0"
  sha256 "955fa5550e7786f1d811fbcaa30c782313d08251600799843c91bc2764212410"

  def install
    (buildpath/"test.cpp").write <<-EOS.undent
    #include <OpenGL/OpenGL.h>
    int main() { return 0; }
    EOS

    system ENV.cc, "test.cpp", "-o", "test"
    bin.install "test"
  end

  test do
    system "#{bin}/test"
  end
end
