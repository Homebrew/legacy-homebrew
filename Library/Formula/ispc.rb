require "formula"

class Ispc < Formula
  homepage "http://ispc.github.io"
  url "https://downloads.sourceforge.net/project/ispcmirror/v1.7.0/ispc-v1.7.0-osx.tar.gz"
  sha1 "ff5ee40ba0eb7313b7dc25ceb1e107da058dae65"

  def install
    bin.install "ispc"
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
