require "formula"

class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://downloads.sourceforge.net/project/ispcmirror/v1.8.0/ispc-v1.8.0-osx.tar.gz"
  sha1 "e645860d2167daa2ffb2fa0cba17df156e1136fc"

  def install
    bin.install "ispc"
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
