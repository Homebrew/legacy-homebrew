class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://downloads.sourceforge.net/project/ispcmirror/v1.8.2/ispc-v1.8.2-osx.tar.gz"
  sha256 "9e42d7cca73e598d26727e4e5ab2f8b8e24d009fcb64424e566fa0f45329c2ec"

  bottle :unneeded

  def install
    bin.install "ispc"
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
