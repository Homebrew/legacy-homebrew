class Dtc < Formula
  homepage "http://www.devicetree.org/"
  url "https://mirrors.kernel.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  sha256 "f5f9a1aea478ee6dbcece8907fd4551058fe72fc2c2a7be972e3d0b7eec4fa43"
  version "1.4.0"

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
