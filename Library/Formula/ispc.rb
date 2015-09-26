class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://downloads.sourceforge.net/project/ispcmirror/v1.8.0/ispc-v1.8.0-osx.tar.gz"
  sha256 "2ca90ae542d99b6e9728f5338b4b0fd502ab22319da56d5b5b42a0b5c7f7c1e6"

  def install
    bin.install "ispc"
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
