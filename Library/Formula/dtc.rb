class Dtc < Formula
  desc "Device tree compiler"
  homepage "http://www.devicetree.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  version "1.4.0"
  sha256 "f5f9a1aea478ee6dbcece8907fd4551058fe72fc2c2a7be972e3d0b7eec4fa43"

  bottle do
    cellar :any
    revision 1
    sha256 "0213fcb000d66a99c2c97f63d07ae36d949daba0f73a23ddbe57b8e6291b9099" => :el_capitan
    sha256 "ed550f87fdb51917cb90124e41f2580508785d47c32e16e10c0637256e171585" => :yosemite
    sha256 "dc180d41f215564fe6b161d9be8aa88cf50519c9f4035a2c08f88cfe59efedc9" => :mavericks
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
