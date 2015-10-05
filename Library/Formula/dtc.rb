class Dtc < Formula
  desc "Device tree compiler"
  homepage "http://www.devicetree.org/"
  url "https://mirrors.kernel.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  version "1.4.0"
  sha256 "f5f9a1aea478ee6dbcece8907fd4551058fe72fc2c2a7be972e3d0b7eec4fa43"

  bottle do
    cellar :any
    sha256 "ba55dfdbd077afbde00be9c4f7ee8b32e73911e56f44a1b9cf9533029f7b31b9" => :yosemite
    sha256 "65e84dddfb0294efa850a0391fc5c977c8ccb3346e72447808a773e7bb6117d3" => :mavericks
    sha256 "112f70543912a0eafc4bc7b890364e7e83e9a5c6f0e3b192bb0917fb98da91d2" => :mountain_lion
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
    mv lib/"libfdt.dylib.1", lib/"libfdt.1.dylib"
  end

  test do
    (testpath/"test.dts").write <<-EOS.undent
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
